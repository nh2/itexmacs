/*  $Header: /home/cvsroot/dvipdfmx/src/agl.c,v 1.34 2009/09/18 23:56:02 matthias Exp $

    This is dvipdfmx, an eXtended version of dvipdfm by Mark A. Wicks.

    Copyright (C) 2007 by Jin-Hwan Cho and Shunsaku Hirata,
    the dvipdfmx project team <dvipdfmx@project.ktug.or.kr>

    Copyright (C) 1998, 1999 by Mark A. Wicks <mwicks@kettering.edu>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*/

/*
 * References:
 *
 *  Unicode and Glyph Names, ver. 2.3., Adobe Solution Network
 *  http://partners.adobe.com/asn/tech/type/unicodegn.jsp
 */

#if HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include <ctype.h>

#include "system.h"
#include "mem.h"
#include "error.h"

#include "mfileio.h"
#include "pdfparse.h"

/* Hash */
#include "dpxutil.h"

#include "dpxfile.h"

#include "unicode.h"

#include "agl.h"

static int verbose = 0;

void
agl_set_verbose (void)
{
  verbose++;
}

static agl_name *
agl_new_name (void)
{
  agl_name *agln;

  agln = NEW(1, agl_name);
  agln->name   = NULL;
  agln->suffix = NULL;
  agln->n_components = 0;
  agln->alternate = NULL;
  agln->is_predef = 0;

  return agln;
}

static void
agl_release_name (agl_name *agln)
{
  agl_name *next;

  while (agln) {
    next = agln->alternate;
    if (agln->name)
      RELEASE(agln->name);
    if (agln->suffix)
      RELEASE(agln->suffix);
    agln->name = NULL;
    RELEASE(agln);
    agln = next;
  }
}

char *
agl_chop_suffix (const char *glyphname, char **suffix)
{
  char  *name, *p;
  int    len;

  ASSERT(glyphname && suffix);

  p = strchr(glyphname, '.');
  if (p) {
    len = strlen(glyphname) - strlen(p);
    if (len < 1) {
      name = NULL;
      *suffix = NEW(strlen(glyphname), char);
      strcpy(*suffix, glyphname+1);
    } else {
      p++;
      name = NEW(len + 1, char);
      strncpy(name, glyphname, len);
      name[len] = '\0';
      if (p[0] == '\0') {
	*suffix = NULL;
      } else {
	*suffix = NEW(strlen(p) + 1, char);
	strcpy(*suffix, p);
      }
    }
  } else {
    name = NEW(strlen(glyphname) + 1, char);
    strcpy(name, glyphname);
    *suffix = NULL;
  }

  return name;
}

static const char * const modifiers[] = {
  "acute", "breve", "caron", "cedilla", "circumflex",
  "dieresis", "dotaccent", "grave", "hungarumlaut",
  "macron", "ogonek", "ring", "tilde", "commaaccent", 
  "slash",

  /* The following entries are not accent nor something
   * but PS font may have those "small" version...
   */
  "ampersand", "exclam", "exclamdown",
  "question","questiondown",
  NULL
};

static int
skip_capital (char **p, char *endptr)
{
  long slen = 0, len;

  len = (long) (endptr - (*p));

  if (len >= 2 &&
      ((**p == 'A' && *(*p+1) == 'E') ||
       (**p == 'O' && *(*p+1) == 'E'))) {
    *p  += 2;
    slen = 2;
  } else if (len >= 3 &&
	     **p     == 'E' &&
	     *(*p+1) == 't' &&
	     *(*p+2) == 'h') {
    *p  += 3;
    slen = 3;
  } else if (len >= 5 &&
	     **p     == 'T' &&
	     *(*p+1) == 'h' &&
	     *(*p+2) == 'o' &&
	     *(*p+3) == 'r' &&
	     *(*p+4) == 'n') {
    *p  += 5;
    slen = 5;
  } else if (len >= 1 &&
	     **p >= 'A' && **p <= 'Z') {
    *p  += 1;
    slen = 1;
  }

  return slen;
}

static int
skip_modifier (char **p, char *endptr)
{
  long slen = 0, len;
  int  i;

  len = (long) (endptr - (*p));

  for (i = 0; modifiers[i] != NULL; i++) {
    if ((len >= (long)strlen(modifiers[i]) &&
	 !memcmp(*p, modifiers[i], len))) {
      slen = strlen(modifiers[i]);
      *p  += slen;
      break;
    }
  }

  return slen;
}

static int
is_smallcap (const char *glyphname)
{
  long  len, slen;
  char *p, *endptr;

  if (!glyphname)
    return 0;

  p   = (char *) glyphname;
  len = strlen(glyphname);
  if (len < 6 ||
      strcmp(p + len - 5, "small"))
    return 0;

  endptr = p + len - 5;

  len -= 5;
  slen = skip_modifier(&p, endptr);
  if (slen == len)
    return 1;  /* Acutesmall, Gravesmall, etc */
  else if (slen > 0) { /* ??? */
    return 0;
  }

  len -= skip_capital(&p, endptr);
  if (len == 0) {
    return 1;  /* Asmall, AEsmall, etc */
  }

  while (len > 0) { /* allow multiple accent */
    slen = skip_modifier(&p, endptr);
    if (slen == 0)
      return 0;
    len -= slen;
  }

  return 1;
}

#define SUFFIX_LIST_MAX  16
#define AGL_VAR_SMCP_IDX 0
static struct {
  const char   *key;
  const char   *otl_tag;
  const char   *suffixes[SUFFIX_LIST_MAX];
} var_list[] = {
  {"small"       , "smcp", {"sc", NULL}},
  {"swash"       , "swsh", {NULL}},
  {"superior"    , "sups", {NULL}},
  {"inferior"    , "sinf", {NULL}},
  {"numerator"   , "numr", {NULL}},
  {"denominator" , "dnom", {NULL}},
  {"oldstyle"    , "onum", {NULL}},

  /* The following only used by TeX, there are no
   * corresponding OTL feat. tag.
   */
  {"display" , NULL, {NULL}},
  {"text"    , NULL, {NULL}},
  {"big"     , NULL, {NULL}},
  {"bigg"    , NULL, {NULL}},
  {"Big"     , NULL, {NULL}},
  {"Bigg"    , NULL, {NULL}},
  {NULL, NULL, {NULL}}
};

const char *
agl_suffix_to_otltag (const char *suffix)
{
  int i, j;
  
  for (i = 0; var_list[i].key; i++) {
    for (j = 0; var_list[i].suffixes[j]; j++) {
      if (!strcmp(suffix, var_list[i].suffixes[j]))
        return var_list[i].otl_tag; 
    }
    if (!strcmp(suffix, var_list[i].key))
      return var_list[i].otl_tag;
    if (var_list[i].otl_tag &&
	!strcmp(suffix, var_list[i].otl_tag))
      return var_list[i].otl_tag;
  }
  
  return NULL;
}

static int
agl_guess_name (const char *glyphname)
{
  int i, len;

  if (is_smallcap(glyphname))
    return AGL_VAR_SMCP_IDX;

  len = strlen(glyphname);
  for (i = 1; var_list[i].key != NULL; i++) {
    if (len > (int)strlen(var_list[i].key) &&
	!strcmp(glyphname+len-strlen(var_list[i].key), var_list[i].key)
	) {
      return i;
    }
  }

  return -1;
}

static agl_name *
agl_normalized_name (char *glyphname)
{
  agl_name *agln;
  char     *suffix;
  int       i, n;

  if (!glyphname)
    return NULL;

  agln   = agl_new_name();
  suffix = strchr(glyphname, '.');
  if (suffix) {
    n = strlen(glyphname) - strlen(suffix);
    if (suffix[1] != '\0') {
      agln->suffix = NEW(strlen(suffix), char);
      strcpy(agln->suffix, suffix+1);
    }
    agln->name    = NEW(n+1, char);
    memcpy(agln->name, glyphname, n);
    agln->name[n] = '\0';
  } else if (is_smallcap(glyphname)) {
    n = strlen(glyphname) - 5;
    agln->suffix = NEW(3, char);
    strcpy(agln->suffix, "sc");
    agln->name   = NEW(n+1, char);
    for (i = 0; i < n; i++) {
      agln->name[i] = isupper(glyphname[i]) ?
	(glyphname[i] + 32) : glyphname[i];
    }
    agln->name[n] = '\0';
  } else {
    int var_idx;

#define SET_STRING(p,s) do {\
  (p) = NEW(strlen((s))+1, char);\
  strcpy((p),(s));\
} while (0)
    var_idx = agl_guess_name(glyphname);
    if (var_idx < 0 ||
        !var_list[var_idx].key) {
        n = strlen(glyphname);
    } else {
        n = strlen(glyphname) - strlen(var_list[var_idx].key);
        if (var_list[var_idx].suffixes[0])
            SET_STRING(agln->suffix, var_list[var_idx].suffixes[0]);
        else {
            SET_STRING(agln->suffix, var_list[var_idx].key);
        }
    }
    agln->name    = NEW(n+1, char);
    memcpy(agln->name, glyphname, n);
    agln->name[n] = '\0';
  }
  
  return agln;
}

static struct ht_table aglmap;

static void CDECL
hval_free (void *hval)
{
  agl_release_name((struct agl_name *) hval);
}

void
agl_init_map (void)
{
  ht_init_table(&aglmap, hval_free);
  agl_load_listfile(AGL_EXTRA_LISTFILE, 0);
  if (agl_load_listfile(AGL_PREDEF_LISTFILE, 1) < 0) {
    WARN("Failed to load AGL file \"%s\"...", AGL_PREDEF_LISTFILE);
  }
  if (agl_load_listfile(AGL_DEFAULT_LISTFILE, 0) < 0) {
    WARN("Failed to load AGL file \"%s\"...", AGL_DEFAULT_LISTFILE);
  }
}

void
agl_close_map (void)
{
  ht_clear_table(&aglmap);
}

#define WBUF_SIZE 1024

int
agl_load_listfile (const char *filename, int is_predef)
{
  int   count = 0;
  char *p, *endptr, *nextptr;
  char  wbuf[WBUF_SIZE];
  FILE *fp;

  if (!filename)
    return  -1;

  fp = DPXFOPEN(filename, DPX_RES_TYPE_AGL);
  if (!fp) {
    return -1;
  }

  if (verbose)
    MESG("<AGL:%s", filename);

  while ((p = mfgets(wbuf, WBUF_SIZE, fp)) != NULL) {
    agl_name *agln, *duplicate;
    char     *name;
    int       n_unicodes, i;
    long      unicodes[AGL_MAX_UNICODES];

    endptr = p + strlen(p);
    skip_white(&p, endptr);

    /* Need table version check. */
    if (!p || p[0] == '#' || p >= endptr)
      continue;
    nextptr = strchr(p, ';');
    if (!nextptr || nextptr == p)
      continue;

    name = parse_ident(&p, nextptr);

    skip_white(&p, endptr);
    if (!name || p[0] != ';') {
      WARN("Invalid AGL entry: %s", wbuf);
      if (name)
        RELEASE(name);
      continue;
    }

    p++;
    skip_white(&p, endptr);

    n_unicodes = 0;
    while (p < endptr &&
           ((p[0]  >= '0' && p[0] <= '9') ||
            (p[0]  >= 'A' && p[0] <= 'F'))
          ) {

      if (n_unicodes >= AGL_MAX_UNICODES) {
        WARN("Too many Unicode values");
        break;
      }
      unicodes[n_unicodes++] = strtol(p, &nextptr, 16);

      p = nextptr;
      skip_white(&p, endptr);
    }

    if (n_unicodes == 0) {
      WARN("AGL entry ignored (no mapping): %s", wbuf);
      RELEASE(name);
      continue;
    }

    agln = agl_normalized_name(name);
    agln->is_predef = is_predef;
    agln->n_components = n_unicodes;
    for (i = 0; i < n_unicodes; i++) {
      agln->unicodes[i] = unicodes[i];
    }

    duplicate = ht_lookup_table(&aglmap, name, strlen(name));
    if (!duplicate)
      ht_append_table(&aglmap, name, strlen(name), agln);
    else {
      while (duplicate->alternate)
        duplicate = duplicate->alternate;
      duplicate->alternate = agln;
    }

    if (verbose > 3) {
      if (agln->suffix)
        MESG("agl: %s [%s.%s] -->", name, agln->name, agln->suffix);
      else
        MESG("agl: %s [%s] -->", name, agln->name);
      for (i = 0; i < agln->n_components; i++) {
        if (agln->unicodes[i] > 0xffff) {
          MESG(" U+%06X", agln->unicodes[i]);
        } else {
          MESG(" U+%04X", agln->unicodes[i]);
        }
      }
      MESG("\n");
    }

    RELEASE(name);
    count++;
  }
  DPXFCLOSE(fp);

  if (verbose)
    MESG(">");

  return count;
}

agl_name *
agl_lookup_list (const char *glyphname)
{
  agl_name *agln;

  if (!glyphname)
    return NULL;

  agln = ht_lookup_table(&aglmap, glyphname, strlen(glyphname));

  return agln;
}

int
agl_name_is_unicode (const char *glyphname)
{
  char c, *suffix;
  int  i, len;

  if (!glyphname)
    return 0;

  suffix = strchr(glyphname, '.');
  len    = (int) (suffix ? suffix - glyphname : (int)strlen(glyphname));
  /*
   * uni02ac is invalid glyph name and mapped to th empty string.
   */
  if (len >= 7 && (len - 3) % 4 == 0 &&
      !strncmp(glyphname, "uni", 3)) {
    c = glyphname[3];
    /*
     * Check if the 4th character is uppercase hexadecimal digit.
     * "union" should not be treated as Unicode glyph name.
     */
    if (isdigit(c) || (c >= 'A' && c <= 'F'))
      return 1;
    else
      return 0;
  } else if (len <= 7 && len >= 5 &&
	     glyphname[0] == 'u') {
    for (i = 1; i < len - 1; i++) {
      c = glyphname[i];
      if (!isdigit(c) && (c < 'A' || c > 'F'))
	return 0;
    }
    return 1;
  }

  return 0;
}

long
agl_name_convert_unicode (const char *glyphname)
{
  long  ucv = -1;
  char *p;

  if (!agl_name_is_unicode(glyphname))
    return -1;

  if (strlen(glyphname) > 7 && *(glyphname+7) != '.') {
    WARN("Mapping to multiple Unicode characters not supported.");
    return -1;
  }

  if (glyphname[1] == 'n')
    p = (char *) (glyphname + 3);
  else
    p = (char *) (glyphname + 1);
  ucv = 0;
  while (*p != '\0' && *p != '.') {
    if (!isdigit(*p) && (*p < 'A' || *p > 'F')) {
      WARN("Invalid char %c in Unicode glyph name %s.", *p, glyphname);
      return -1;
    }
    ucv <<= 4;
    ucv += isdigit(*p) ? *p - '0' : *p - 'A' + 10;
    p++;
  }

  if (!UC_is_valid(ucv)) {
    if (ucv < 0x10000) {
      WARN("Invalid Unicode code value U+%04X.", ucv);
    } else {
      WARN("Invalid Unicode code value U+%06X.", ucv);
    }
    ucv = -1;
  }

  return ucv;
}



static long
xtol (const char *start, int len)
{
  long v = 0;

  while (len-- > 0) {
    v <<= 4;
    if (isdigit(*start)) {
      v += *start - '0';
    } else if (*start >= 'A' && *start <= 'F') {
      v += *start - 'A' + 10;
    } else {
      return -1;
    }
    start++;
  }

  return v;
}

#define IS_PUA(u) (((u) >= 0x00E000L && (u) <= 0x00F8FFL) || \
  ((u) >= 0x0F0000L && (u) <= 0x0FFFFDL) || \
  ((u) >= 0x100000L && (u) <= 0x10FFFDL) \
)

static long
put_unicode_glyph (const char *name,
		   unsigned char **dstpp, unsigned char *limptr)
{
  char *p;
  long  len = 0, ucv;

  p   = (char *) name;
  ucv = 0;

  if (p[1] != 'n') {
    p   += 1;
    ucv  = xtol(p, strlen(p));
    len += UC_sput_UTF16BE (ucv, dstpp, limptr);
  } else {
    p += 3;
    while (*p != '\0') {
      ucv  = xtol(p, 4);
      len += UC_sput_UTF16BE (ucv, dstpp, limptr);
      p   += 4;
    }
  }

  return len;
}

long
agl_sput_UTF16BE (const char *glyphstr,
		  unsigned char **dstpp, unsigned char *limptr,
		  int *fail_count)
{
  long  len   = 0;
  int   count = 0;
  char *p, *endptr;

  ASSERT(glyphstr && dstpp);

  p      = (char *) glyphstr;
  endptr = strchr(p, '.');
  if (!endptr)
    endptr = p + strlen(p);

  while (p < endptr) {
    char     *name, *delim;
    long      sub_len;
    int       i;
    agl_name *agln0, *agln1 = NULL;

    delim = strchr(p, '_');
    if (delim == p) {
      /*
       * Glyph names starting with a underscore or two subsequent
       * underscore in glyph name not allowed?
       */
      WARN("Invalid glyph name component in \"%s\".", glyphstr);
      count++;
      if (fail_count)
	*fail_count = count;
      return len; /* Cannot continue */
    } else if (!delim || delim > endptr) {
      delim = endptr;
    }
    sub_len = (long) (delim - p);

    name = NEW(sub_len+1, char);
    memcpy(name, p, sub_len);
    name[sub_len] = '\0';

    if (agl_name_is_unicode(name)) {
      sub_len = put_unicode_glyph(name, dstpp, limptr);
      if (sub_len > 0)
	len += sub_len;
      else {
	count++;
      }
    } else {
      agln1 = agl_lookup_list(name);
      if (!agln1 || (agln1->n_components == 1 &&
		     IS_PUA(agln1->unicodes[0]))) {
	agln0 = agl_normalized_name(name);
	if (agln0) {
	  if (verbose > 1 && agln0->suffix) {
	    WARN("agl: fix %s --> %s.%s",
		 name, agln0->name, agln0->suffix);
	  }
	  agln1 = agl_lookup_list(agln0->name);
	  agl_release_name(agln0);
	}
      }
      if (agln1) {
	for (i = 0; i < agln1->n_components; i++) {
	  len += UC_sput_UTF16BE (agln1->unicodes[i], dstpp, limptr);
	}
      } else {
	if (verbose) {
	  WARN("No Unicode mapping for glyph name \"%s\" found.", name);
	}
	count++;
      }
    }
    RELEASE(name);
    p = delim + 1;
  }

  if (fail_count)
    *fail_count = count;
  return len;
}

int
agl_get_unicodes (const char *glyphstr,
		  long *unicodes, int max_unicodes)
{
  int   count = 0;
  char *p, *endptr;

  p      = (char *) glyphstr;
  endptr = strchr(p, '.');
  if (!endptr)
    endptr = p + strlen(p);

  while (p < endptr) {
    char     *name, *delim;
    long      sub_len;
    int       i;
    agl_name *agln0, *agln1 = NULL;

    delim = strchr(p, '_');
    if (delim == p) {
      /*
       * Glyph names starting with a underscore or two subsequent
       * underscore in glyph name not allowed?
       */
      WARN("Invalid glyph name component in \"%s\".", glyphstr);
      return -1; /* Cannot continue */
    } else if (!delim || delim > endptr) {
      delim = endptr;
    }
    sub_len = (long) (delim - p);

    name = NEW(sub_len+1, char);
    memcpy(name, p, sub_len);
    name[sub_len] = '\0';

    if (agl_name_is_unicode(name)) {
      p  = name;
      if (p[1] != 'n') { /* uXXXXXXXX */
	if (count >= max_unicodes) {
	  RELEASE(name);
	  return -1;
	}
	p++;
	unicodes[count++] = xtol(p, strlen(p));
      } else {
	p += 3;
	while (*p != '\0') {
	  if (count >= max_unicodes) {
	    RELEASE(name);
	    return -1;
	  }
	  unicodes[count++] = xtol(p, 4);
	  p += 4;
	}
      }
    } else {
      agln1 = agl_lookup_list(name);
      if (!agln1 || (agln1->n_components == 1 &&
		     IS_PUA(agln1->unicodes[0]))) {
	agln0 = agl_normalized_name(name);
	if (agln0) {
	  if (verbose > 1 && agln0->suffix) {
	    WARN("agl: fix %s --> %s.%s",
		 name, agln0->name, agln0->suffix);
	  }
	  agln1 = agl_lookup_list(agln0->name);
	  agl_release_name(agln0);
	}
      }
      if (agln1) {
	if (count + agln1->n_components > max_unicodes) {
	  RELEASE(name);
	  return -1;
	}
	for (i = 0; i < agln1->n_components; i++) {
	  unicodes[count++] = agln1->unicodes[i];
	}
      } else {
	if (verbose > 1)
	  WARN("No Unicode mapping for glyph name \"%s\" found.", name);
	RELEASE(name);
	return -1;
      }
    }
    RELEASE(name);
    p = delim + 1;
  }

  return count;
}
