<TeXmacs|1.0.3.4>

<style|source>

<\body>
  <active*|<\src-title>
    <src-package-dtd|header-exam|1.0|header-exam|1.0>

    <\src-purpose>
      Headers for exams.
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

  <use-package|header-generic>

  \;

  <assign|class*|<macro|body|<arg|body>>>

  <assign|class|<macro|body|<no-indent><class*|<arg|body>><left-flush>>>

  <assign|title-date*|<macro|body|<arg|body>>>

  <assign|title-date|<macro|body|<right-flush><title-date*|<arg|body>>>>

  <assign|title*|<macro|body|<with|math-font-series|bold|font-series|bold|font-size|1.30|font-shape|small-caps|<arg|body>>>>

  <assign|title|<\macro|body>
    <\with|par-mode|center>
      <surround|<vspace*|0.5fn>|<vspace|2fn>|<title*|<arg|body>>>
    </with>
  </macro>>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-bot|30mm>
    <associate|page-even|30mm>
    <associate|page-odd|30mm>
    <associate|page-reduce-bot|15mm>
    <associate|page-reduce-left|25mm>
    <associate|page-reduce-right|25mm>
    <associate|page-reduce-top|15mm>
    <associate|page-right|30mm>
    <associate|page-top|30mm>
    <associate|page-type|a4>
    <associate|par-width|150mm>
    <associate|preamble|true>
    <associate|sfactor|4>
  </collection>
</initial>