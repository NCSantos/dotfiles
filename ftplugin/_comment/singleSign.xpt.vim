XPTemplate priority=all-


XPTinclude
      \ _comment/common



XPT _s_comment hidden wrap		" $CS ..
`$CS `cursor^


XPT _s_commentBlock hidden wrap	" $CS ..
`$CS `cursor^


XPT _s_commentDoc hidden wrap	" $CS ..
`$CS^
`$CS `cursor^
`$CS^

XPT _s_commentLine hidden wrap	" $CS ..
`$CS `cursor^


XPT comment      alias=_s_comment
XPT commentBlock alias=_s_commentBlock
XPT commentDoc   alias=_s_commentDoc
XPT commentLine  alias=_s_commentLine

