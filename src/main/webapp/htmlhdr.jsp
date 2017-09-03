<%--
 * The MIT License
 *
 * Copyright 2017 Simon Schmidt.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Krauts Forum</title>
<style>
    body{
        font-family: Arial,Helvetica,San-serif;
    }
    #subbody{
        margin: 0px auto;
        padding: 0px;
        height: auto;
        text-align: left;
    }
    .u { text-decoration: underline; }
    .strike { text-decoration: line-through; }
    .overline { text-decoration: overline; }
    /*
    th, td {
        border: 1px solid #ccc;
    }
    */
    /*
    th, td {
        border: 1px solid #fcc;
    }
    */
    .redlink { color: #F00;}
    .redlink a:link, .redlink a:visited{ color: #F00; }
    blockquote {
        margin-bottom: 0.5em;
        margin-top: 0.5em;
        margin-left: 0.1em;
        padding: 0;
        color: rgb(153, 0 ,0);
        padding-left: 0.6em;
        border-left: solid 4px;
        background-image: none;
    }
    blockquote .who {
        color: #aaa;
        display: block;
        font-size: 10pt;
        /*quotes: "\201E" "\201C" "\201A " "\2018";*/
    }
    blockquote .who:before {
        color: #000;
        content: "By: ";
    }
</style>