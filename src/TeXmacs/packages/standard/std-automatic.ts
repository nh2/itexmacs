<TeXmacs|1.0.7>

<style|source>

<\body>
  <active*|<\src-title>
    <src-package|std-automatic|1.0>

    <\src-purpose>
      This package contains macros for the automatic generation of content
      (citations, tables of contents, indexes and glossaries) and the
      rendering of such content.
    </src-purpose>

    <src-copyright|1998--2004|Joris van der Hoeven>

    <\src-license>
      This software falls under the <hlink|GNU general public
      license, version 3 or later|$TEXMACS_PATH/LICENSE>.
      It comes WITHOUT ANY WARRANTY WHATSOEVER.
      You should have received a copy of the license which the software.
      If not, see <hlink|http://www.gnu.org/licenses/gpl-3.0.html|http://www.gnu.org/licenses/gpl-3.0.html>.
    </src-license>
  </src-title>>

  <\active*>
    <\src-comment>
      Automatically generated labels.
    </src-comment>
  </active*>

  <new-counter|auto>

  <assign|current-part|>

  <assign|set-part|<macro|id|body|<with|current-part|<merge|<value|current-part>|.|<arg|id>>|auto-nr|0|<arg|body>>>>

  <assign|the-auto|<macro|<merge|auto|<value|current-part>|-|<value|auto-nr>>>>

  <assign|auto-label|<macro|<inc-auto><label|<the-auto>>>>

  <\active*>
    <\src-comment>
      Citations.
    </src-comment>
  </active*>

  <assign|render-cite|<macro|x|[<arg|x>]>>

  <assign|render-cite-detail|<macro|x|y|<render-cite|<arg|x>, <arg|y>>>>

  <assign|cite-bib|bib>

  <assign|cite-sep|<macro|, >>

  <assign|cite-arg|<macro|x|<write|<value|cite-bib>|<arg|x>><reference|<merge|<value|cite-bib>|-|<arg|x>>>>>

  <assign|cite-arg-extra|<macro|x|<cite-sep><cite-arg|<arg|x>>>>

  <assign|cite|<xmacro|x|<render-cite|<cite-arg|<arg|x|0>><map-args|cite-arg-extra|concat|x|1>>>>

  <assign|cite-detail|<macro|x|y|<render-cite-detail|<cite-arg|<arg|x>>|<arg|y>>>>

  <assign|cite-raw|<xmacro|x|<cite-arg|<arg|x|0>><map-args|cite-arg-extra|concat|x|1>>>

  <assign|nocite-arg|<macro|x|<write|<value|cite-bib>|<arg|x>>>>

  <assign|nocite|<xmacro|x|<style-with|src-compact|none|<flag|<localize|bibliography>|dark
  green|x><map-args|nocite-arg|concat|x>>>>

  \;

  <assign|transform-bibitem|<macro|x|<strong|[<arg|x>] \ >>>

  <assign|render-bibitem|<macro|text|<compact-item|<transform-bibitem|<arg|text>>>>>

  <assign|bibitem|<macro|text|<style-with|src-compact|none|<bibitem*|<arg|text>><label|<merge|<value|cite-bib>|-|<arg|text>>>>>>

  <assign|bibitem*|<macro|text|<style-with|src-compact|none|<render-bibitem|<arg|text>><set-binding|<arg|text>>>>>

  <assign|protect|>

  <assign|newblock|>

  <assign|citeauthoryear|<macro|author|year|<arg|author> <arg|year>>>

  <assign|bib-list|<\macro|largest|body>
    <\with|bibitem-width|<box-info|<transform-bibitem|<arg|largest>>|w.>>
      <\description>
        <arg|body>
      </description>
    </with>
  </macro>>

  <\active*>
    <\src-comment>
      Tables of contents.
    </src-comment>
  </active*>

  <assign|toc-entry|<macro|type|what|<quasi|<style-with|src-compact|none|<flag|<localize|table
  of contents>|dark green|what><auto-label><write|toc|<compound|<unquote|<arg|type>>|<arg|what>|<pageref|<the-auto>>>>>>>>

  <assign|toc-main-1|<macro|what|<toc-entry|toc-strong-1|<arg|what>>>>

  <assign|toc-main-2|<macro|what|<toc-entry|toc-strong-2|<arg|what>>>>

  <assign|toc-normal-1|<macro|what|<toc-entry|toc-1|<arg|what>>>>

  <assign|toc-normal-2|<macro|what|<toc-entry|toc-2|<arg|what>>>>

  <assign|toc-normal-3|<macro|what|<toc-entry|toc-3|<arg|what>>>>

  <assign|toc-small-1|<macro|what|<toc-entry|toc-4|<arg|what>>>>

  <assign|toc-small-2|<macro|what|<toc-entry|toc-5|<arg|what>>>>

  \;

  <assign|toc-dots|<macro| <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
  >>

  <assign|toc-strong-1|<macro|left|right|<vspace*|2fn><with|font-series|bold|math-font-series|bold|font-size|1.19|<arg|left>><toc-dots><no-break><arg|right><vspace|1fn>>>

  <assign|toc-strong-2|<macro|left|right|<vspace*|1fn><with|font-series|bold|math-font-series|bold|<arg|left>><toc-dots><no-break><arg|right><vspace|0.5fn>>>

  <assign|toc-1|<macro|left|right|<arg|left><toc-dots><no-break><arg|right>>>

  <assign|toc-2|<macro|left|right|<with|par-left|1.5fn|<arg|left><toc-dots><no-break><arg|right>>>>

  <assign|toc-3|<macro|left|right|<with|par-left|3fn|<arg|left><toc-dots><no-break><arg|right>>>>

  <assign|toc-4|<macro|left|right|<with|par-left|6fn|<arg|left><toc-dots><no-break><arg|right><vspace|0.15fn>>>>

  <assign|toc-5|<macro|left|right|<arg|left><toc-dots><no-break><arg|right><vspace|0.15fn>>>

  <\active*>
    <\src-comment>
      Indexes.
    </src-comment>
  </active*>

  <assign|index-line|<macro|key|entry|<style-with|src-compact|none|<flag|<localize|index>|dark
  green|key><write|idx|<tuple|<arg|key>||<arg|entry>>>>>>

  <assign|index-write|<macro|entry|<style-with|src-compact|none|<auto-label><write|idx|<tuple|<arg|entry>|<pageref|<the-auto>>>>>>>

  <assign|index|<macro|x|<style-with|src-compact|none|<flag|<localize|index>|dark
  green|x><index-write|<tuple|<arg|x>>>>>>

  <assign|subindex|<macro|x|y|<style-with|src-compact|none|<flag|<localize|index>|dark
  green|x><index-write|<tuple|<arg|x>|<arg|y>>>>>>

  <assign|subsubindex|<macro|x|y|z|<style-with|src-compact|none|<flag|<localize|index>|dark
  green|x><index-write|<tuple|<arg|x>|<arg|y>|<arg|z>>>>>>

  <assign|subsubsubindex|<macro|x|y|z|a|<style-with|src-compact|none|<flag|<localize|index>|dark
  green|x><index-write|<tuple|<arg|x>|<arg|y>|<arg|z>|<arg|a>>>>>>

  <assign|index-complex|<macro|key|how|range|entry|<style-with|src-compact|none|<flag|<localize|index>|dark
  green|key><auto-label><write|idx|<tuple|<arg|key>|<arg|how>|<arg|range>|<arg|entry>|<pageref|<the-auto>>>>>>>

  \;

  <assign|index-dots|<macro| <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
  >>

  <assign|index-1|<macro|left|right|<arg|left><index-dots><arg|right>>>

  <assign|index-1*|<macro|left|<arg|left><no-page-break>>>

  <assign|index-2|<macro|left|right|<with|par-left|1.5fn|<arg|left><index-dots><arg|right>>>>

  <assign|index-2*|<macro|left|<with|par-left|1.5fn|<arg|left><no-page-break>>>>

  <assign|index-3|<macro|left|right|<with|par-left|3fn|<arg|left><index-dots><arg|right>>>>

  <assign|index-3*|<macro|left|<with|par-left|3fn|<arg|left><no-page-break>>>>

  <assign|index-4|<macro|left|right|<with|par-left|4.5fn|<arg|left><index-dots><arg|right>>>>

  <assign|index-4*|<macro|left|<with|par-left|4.5fn|<arg|left><no-page-break>>>>

  <assign|index-5|<macro|left|right|<with|par-left|6fn|<arg|left><index-dots><arg|right>>>>

  <assign|index-5*|<macro|left|<with|par-left|6fn|<arg|left><no-page-break>>>>

  <\active*>
    <\src-comment>
      Glossaries.
    </src-comment>
  </active*>

  <assign|glossary-line|<macro|entry|<style-with|src-compact|none|<flag|<localize|glossary>|dark
  green|entry><write|gly|<tuple|<arg|entry>>>>>>

  <assign|glossary|<macro|entry|<style-with|src-compact|none|<flag|<localize|glossary>|dark
  green|entry><auto-label><write|gly|<tuple|normal|<arg|entry>|<pageref|<the-auto>>>>>>>

  <assign|glossary-explain|<macro|entry|explain|<style-with|src-compact|none|<flag|<localize|glossary>|dark
  green|entry><auto-label><write|gly|<tuple|normal|<arg|entry>|<arg|explain>|<pageref|<the-auto>>>>>>>

  <assign|glossary-dup|<macro|entry|<style-with|src-compact|none|<flag|<localize|glossary>|dark
  green|entry><auto-label><write|gly|<tuple|dup|<arg|entry>|<pageref|<the-auto>>>>>>>

  \;

  <assign|glossary-dots|<macro| <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
  >>

  <assign|glossary-1|<macro|left|right|<arg|left><glossary-dots><no-break><arg|right>>>

  <assign|glossary-2|<macro|entry|explain|right|<margin-first-other|0fn|10fn|<style-with|src-compact|none|<resize|<arg|entry>
  |||r]10fn|><arg|explain><glossary-dots><no-break><arg|right>>>>>

  \;
</body>

<\initial>
  <\collection>
    <associate|preamble|true>
  </collection>
</initial>