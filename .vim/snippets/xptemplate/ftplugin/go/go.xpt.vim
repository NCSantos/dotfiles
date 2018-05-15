XPTemplate priority=personal

" shorthand variable declaration
XPT : " v := value
`^ := `^

" anonymous function
XPT anon " fn := func\() { ... }
`fn^ := func() {
    `cursor^
}

" append
XPT ap " append\(slice, value)
append(`slice^, `value^)

" append assignment
XPT ap= " a = append\(a, value)
`slice^ = append(`slice^, `value^)

" break
XPT br " break
break

" channel
XPT ch " chan Type
chan `int^

" constant
XPT con " const XXX type = ...
const `name^ `type^ = `0^

" constants
XPT cons " const \( ... )
const (
    `name^ `type^ = `value^
`    `more...`
{{^    `name^ `type^ = `value^
`    `more...`
^`}}^)

" constants with iota
XPT iota " const \( ... = iota )
const (
    `name^ `type^ = iota
    `cursor^
)

" continue
XPT cn " continue
continue

" defer
XPT df " defer someFunction\()
defer `func^(`^)
`^

XPT def " defer func\() { ... }
defer func() {
    `cursor^
}()

" defer recover
XPT defr
defer func() {
    if err := recover(); err != nil {
        `cursor^
    }
}()

" gpl
XPT gpl
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, see <http://www.gnu.org/licenses/>.
*
* Copyright (C) `Author^, `strftime("%Y")^
*/
`cursor^

" import
XPT import " import \( ... )
import (
    `cursor^
)

" full interface snippet
XPT in " interface I { ... }
type `Interface^ interface {
    `cursor^
}

" if else condition
XPT ife " if ... { ... } else { ... }
if `condition^ {
    `^
} `Include:else^

" if else if condition
XPT ifei " if { ... } else if { ... } else { ... }
if `condition^ {
    `^
`elsif...
{{^} else if `cond^ {
    `^
`elsif...
^`}}^`else...
{{^} else {
    `cursor^
`}}^}

" if inline error
XPT ife " If with inline erro
if err := `condition^; err != nil {
    `cursor^
}

" error snippet
XPT errn " Error return
if err != nil {
    return err
}

" error log snippet
XPT errl " Error with log.Fatal\(err)
if err != nil {
    log.Fatal(err)
}

" error multiple return
XPT errnn " Error return with two return values
if err != nil {
    return `nil^, err
}

" error panic
XPT errp " Error panic
if err != nil {
    panic(`^)
}

" error test
XPT errt " Error test fatal
if err != nil {
    t.Fatal(err)
}

" error handle
XPT errh " Error handle and return
if err != nil {
    `^
    return
}

" json field tag
XPT json " \`json:key\`
\`json:"`matchstr(getline("."), '\w\+')^"\`

" yaml field tag
XPT yaml " \`yaml:key\`
\`yaml:"`matchstr(getline("."), '\w\+')^"\`

" fallthrough
XPT ft " fallthrough
fallthrough

" Fmt Printf debug
XPT ff " fmt.Printf\(...)
fmt.Printf("`^", `^)

" Fmt Println debug
XPT fn " fmt.Println\(...)
fmt.Println("`^")

" Fmt Errorf debug
XPT fe " fmt.Errorf\(...)
fmt.Errorf("`^")

" log printf
XPT lf " log.Printf\(...)
log.Printf("`^", `^)

" log println
XPT ln " log.Println\(...)
log.Println("`^")

" ok
XPT ok " if !ok { ... }
if !ok {
    `cursor^
}

" package
XPT package " package ...
// Package `main^ provides `...^
package `main^
`cursor^

" panic
XPT pn " panic\()
panic("`msg^")

" return
XPT rt " return
return `cursor^

" struct
XPT st " type T struct { ... }
type `Type^ struct {
    `cursor^
}

" " switch
" XPT switch " switch x { ... }
" switch `var^ {
" case `^:
"     `^
" `case...
" {{^case `^:
"     `^
" `case...
" ^`}}^`default...
" {{^default:
"     `cursor^
" `}}^}

" sprintf
XPT sp " fmt.Sprintf\(...)
fmt.Sprintf("%`s^", `var^)

" goroutine named function
XPT go " go someFunc\(...)
go `funcName^(`^)

" goroutine anonymous function
XPT gof " go func\() { ... }\()
go func() {
    `^
}()

XPT hf " http.HandlerFunc
func `handler^(w http.ResponseWriter, r *http.Request) {
    `fmt.Fprintf\(w, "hello world")^
}

XPT hhf " mux.HandleFunc
`http^.HandleFunc("`/^", func(w http.ResponseWriter, r *http.Request) {
    `fmt.Fprintf\(w, "hello world")^
})

" quick test server
XPT tsrv " httptest.NewServer
ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, \``response^\`})
}))
defer ts.Close()

`someUrl^ = ts.URL
..XPT

" test error handling
XPT ter " if err != nil { t.Errorf\(...) }
if err != nil {
    t.Errorf("`message^")
}

" test fatal error
XPT terf " if err != nil { t.Fatalf\(...) }
if err != nil {
    t.Fatalf("`message^")
}

XPT example " func ExampleXYZ\() { ... }
func Example`^() {
    `cursor^
    // Output:
}

XPT bfunc " func BenchmarkXYZ\(b *testing.B) { ... }
func Benchmark`^(b *testing.B) {
    `^
    for i := 0; i < b.N; i++ {
        `cursor^
    }
}

" variable declaration
XPT var " var x Type [= ...]
var `x^ `Type^` `= value...{{^ = `value^`}}^

" variables declaration
XPT vars " var \( ... )
var (
    `x^ `Type^` `= value...{{^ = `value^`}}^
`    `more...`
{{^    `x^ `Type^` `= value...{{^ = `value^`}}^
`    `more...`
^`}}^)
