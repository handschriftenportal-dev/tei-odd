<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:h2="katneu4-2009-12-richedit-illum-neu.xml"
                xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
                xmlns:debug="http://www.startext.de/debug"
                xmlns:tools="http://www.startext.de/tools"
                xmlns:rtftools="http://www.startext.de/rtftools"
                xmlns:htmltools="http://www.startext.de/htmltools" 
                xmlns:user="http://www.startext.de"
                exclude-result-prefixes="msxsl h1 h2 debug tools rtftools htmltools user">



	<!-- #################################################################### -->
	<!--<xsl:output method="text" version="1.0" encoding="ISO-8859-1"/>-->
	<!-- #################################################################### -->



  <!-- #################################################################### -->
  <msxsl:script language="VBScript" implements-prefix="rtftools">
    <![CDATA[



		' ====================================================================
		' Datei-Info =========================================================
		' ====================================================================
		
		
				
		' --------------------------------------------------------------------
		Function setYear ()
			setYear = DatePart( "yyyy", CStr( Date() ) )
		End Function
		' --------------------------------------------------------------------

		
				
		' --------------------------------------------------------------------
		Function setMonth ()
			setMonth = DatePart( "m", CStr( Date() ) )
		End Function
		' --------------------------------------------------------------------

		
				
		' --------------------------------------------------------------------
		Function setDay ()
			setDay = DatePart( "d", CStr( Date() ) )
		End Function
		' --------------------------------------------------------------------

		
				
		' --------------------------------------------------------------------
		Function setHour ()
			setHour = DatePart( "h", CStr( Time() ) )
		End Function
		' --------------------------------------------------------------------

		
				
		' --------------------------------------------------------------------
		Function setMinute ()
			setMinute = DatePart( "n", CStr( Time() ) )
		End Function
		' --------------------------------------------------------------------

		
		
		' ====================================================================
		' Reduzieren, Entfernen ==============================================
		' ====================================================================



    ' --------------------------------------------------------------------
		Function PopUp ( strMsg )
			Dim shell
			
			Set shell = CreateObject( "WScript.Shell" )
			
			shell.Popup strMsg, 0, "JScript message", 0
		End Function
    ' --------------------------------------------------------------------

    
    
		' ====================================================================
		' Reduzieren, Entfernen ==============================================
		' ====================================================================



    ' --------------------------------------------------------------------
		Function reduceRTF ( r )
      reduceRTF = reduceRTF2( r, true )
    End Function
    ' --------------------------------------------------------------------



    ' --------------------------------------------------------------------
		Function reduceRTF1 ( r, bolNormalizeFontSizes )
      Set re = New RegExp

      re.MultiLine  = False
      re.IgnoreCase = False
      re.Global     = True

      ' save normal brackets and backslashes
      re.Pattern = "\\\\"
      r = re.Replace( r, "/BACKSLASH/" )
      re.Pattern = "\\\{"
      r = re.Replace( r, "/BRACKET_OPEN/" )
      re.Pattern = "\\\}"
      r = re.Replace( r, "/BRACKET_CLOSE/" )


	      ' HEADER

	      ' remove rtf-tag and opening and closing braces
	      re.Pattern = "^\{\\rtf1"
	      r = re.Replace( r, "" )
	      re.Pattern = "\}$"
	      r = re.Replace( r, "" )

	      ' remove charset
	      re.Pattern = "\\ansi(cpg-?[0-9]{1,})?"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\upr"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\ud"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\u-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\uc-?[0-9]{1,}"
	      r = re.Replace( r, "" )

	      ' remove deff
	      re.Pattern = "\\deff-?[0-9]{1,}"
	      r = re.Replace( r, "" )

	      ' remove fonttable
	      re.Pattern = "\{\\fonttbl((\{[^\{\}]*\})*[^\{\}]*)*\}"
	      r = re.Replace( r, "" )

	      ' remove filetable
	      re.Pattern = "\{\\\*\\filetbl(\{[^\{\}]*\})*\}"
	      r = re.Replace( r, "" )

	      ' remove colortable
	      re.Pattern = "\{\\colortbl[^\}]*\}"
	      r = re.Replace( r, "" )

	      ' remove stylesheet
	      re.Pattern = "\{\\stylesheet(\{[^\{\}]*\})*\}"
	      r = re.Replace( r, "" )

	      ' remove listtable
	      re.Pattern = "\{\\\*\\listtable((\{((\{((\{[^\{\}]*\})*[^\{\}]*)*\})*[^\{\}]*)*\})*[^\{\}]*)*\}"
	      r = re.Replace( r, "" )

	      ' remove listoverridetable
	      re.Pattern = "\{\\\*\\listoverridetable((\{[^\{\}]*\})*[^\{\}]*)*\}"
	      r = re.Replace( r, "" )

	      ' remove revtable
	      re.Pattern = "\{\\\*\\revtbl[^\}]*\}"
	      r = re.Replace( r, "" )


	      ' DOCUMENT

	      ' remove info
	      re.Pattern = "\{\\info([^\}][^\}])*\}\}"
	      r = re.Replace( r, "" )

	      ' remove docfmt
	      re.Pattern = "\\deftab-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\hyphhotz-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\hyphconsec-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\hyphcaps"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\hyphauto"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\linestart-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\fracwith"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\\*\\nextfile"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\\*\\template"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\makebackup"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\defformat"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\psover"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\doctemp"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\deflang-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\deflangfe-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\windowcaption"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\doctype-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\fromtext"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\fromhtml"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\horzdoc"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\vertdoc"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\jcompress"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\lnongrid"
	      r = re.Replace( r, "" )
	        ' document views and zoom level
	      re.Pattern = "\\viewkind-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\viewscale-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\viewzk-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\private-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	        ' footnotes and endnotes
	          ' ToDo
	        ' page information
	      re.Pattern = "\\paperw-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\paperh-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\psz-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\margl-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\margr-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\margt-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\margb-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\facingp"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\gutter-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\rtlgutter"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\gutterprl"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\margmirror"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\landscape"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgnstart-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\widowctrl"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\twoonone"
	      r = re.Replace( r, "" )
	        ' linked styles
	      re.Pattern = "\\linkstyles"
	      r = re.Replace( r, "" )
	        ' compatibility options
	          ' ToDo
	        ' revision marks
	      re.Pattern = "\\revprot"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\revisions"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\revprop-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\revbar-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	        ' comments
	      re.Pattern = "\\annotprot"
	      r = re.Replace( r, "" )
	        ' bidirectional controls
	      re.Pattern = "\\rtldoc"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\ltrdoc"
	      r = re.Replace( r, "" )
	        ' click and type
	      re.Pattern = "\\cts-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	        ' kinsoku characters
	      re.Pattern = "\\jsksu"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\ksulang-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\\*\\fchars"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\\*\\lchars"
	      r = re.Replace( r, "" )
	        ' drawing grid
	      re.Pattern = "\\dghspace-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\dgvspace-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\dghorigin-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\dgvorigin-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\dghshow-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\dgvshow-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\dgsnap"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\dgmargin"
	      r = re.Replace( r, "" )
	        ' page borders
	      re.Pattern = "\\pgbrdrhead"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgbrdrfoot"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgbrdrt"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgbrdrb"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgbrdrl"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgbrdrr"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\brdrart-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgbrdropt-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	      re.Pattern = "\\pgbrdrsnap"
	      r = re.Replace( r, "" )

	      ' remove styles
	        ' section style
	      re.Pattern = "\\ds-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	        ' paragraph style
	      re.Pattern = "\\s-?[0-9]{1,}"
	      r = re.Replace( r, "" )
	        ' character style
	      re.Pattern = "\\\*\\cs-?[0-9]{1,}"
	      r = re.Replace( r, "" )

	      ' remove fonttypes
	      re.Pattern = "\\f-?[0-9]{1,}"
	      r = re.Replace( r, "" )

	      If bolNormalizeFontSizes Then
		 ' remove fontsizes

                 re.Pattern = "\\fs-?[0-9]{1,}"
                 r = re.Replace(r, "@fs@")

		 ' r = re.Replace( r, "" )
	      End If

	      ' remove whitespaces after 'pard's and 'par's
	      re.Pattern = "\s+\\par(d?)\s+"
	      re.Pattern = "\s*\\par(d?)\s*"

	      r = re.Replace( r, "{\par$1}" )

		      ' remove all 'pard's
		      re.Pattern = "\{\\pard\}"
		      r = re.Replace( r, "" )

	      ' nma !!!
	      ' remove all 'par's at end of document
	      're.Global     = False
	      're.Pattern = "(\{\\par\}|\par|\s|\r?\n\r?|(&#x0d;)?&#x0a;(&#x0d;)?)+$"
	      'r = re.Replace( r, "" )
	      're.Global     = True

	      ' convert normal line breaks ( which are not before '\plain' - resctriction needed for lists ) to 'par's
	      re.Pattern = "(\r?\n\r?|(&#x0d;)?&#x0a;(&#x0d;)?)(!\\plain)"
	      r = re.Replace( r, "\par" )

				' remove some list infos - liststyle are not exported, if references are not removed, numbers will not be displayed
				re.Pattern = "\\listtext|\\ls[1-9]+"
				r = re.Replace( r, "" )

	      'The following part of the script was added by Noél Marx (nma@startext.de) at 10.02.2004, to prevent deleting multiple whitespaces after
	      'text-formating rtf-tags (\i,\b and \u)
	      
		   'italic
	      re.Pattern ="\\i\s"
	      r = re.Replace(r,"@i@")
		   'bold
	      re.Pattern ="\\b\s"
	      r = re.Replace(r,"@b@")
		   'underlined
	      re.Pattern ="\\u\s"
	      r = re.Replace(r,"@u@")
	      
	      	      
	      ' normalize multiple whitespaces
	      re.Pattern = "\s+"
	      r = re.Replace( r, " " )
	      

			're - insert format-tags
			'italic
			re.pattern = "\@i@"
			r = re.Replace(r, "\i ")
			'underlined
			re.pattern = "\@u@"
			r = re.Replace(r, "\u ")
			'bold
			re.pattern = "\@b@"
			r = re.Replace(r, "\b ")
			
			
		
	      ' remove leading and trailing whitespaces
	       re.Pattern = "^\s+|\s+$"
	       r = re.Replace( r, "" )

      ' restore normal brackets and backslashes
      re.Pattern = "/BRACKET_CLOSE/"
      r = re.Replace( r, "\}" )
      re.Pattern = "/BRACKET_OPEN/"
      r = re.Replace( r, "\{" )
      re.Pattern = "/BACKSLASH/"
      r = re.Replace( r, "\\" )

	'added by Filip Petkov to prevent deleting of the first chars of the word
	'fs
	re.pattern = "\@fs@"
	r=re.Replace(r, "")

	
	'added by Filip Petkov, when this function be called from reduceRTF3 than the whitespaces in the text are not deleted
	'and the output is wrong
	      ' normalize multiple whitespaces
	      're.Pattern = "\s+"
	      'r = re.Replace( r, " " )

      reduceRTF1 = r
    End Function
    ' --------------------------------------------------------------------



' --------------------------------------------------------------------
Function reduceRTF2 ( strRTF, strStyle )
      Set re = New RegExp
      
	
      re.MultiLine  = False
      re.IgnoreCase = False
      re.Global     = True

      ' remove plains
      re.Pattern = "\\plain(?![a-zA-Z0-9])(\s*)"


      'if strStyle = "true" then strStyle = ""

      if IsRtf(strRTF) then
	      strRTF = "\plain" & strStyle & re.Replace( reduceRTF1(strRTF, true), "\plain" & trim(strStyle) & " ")
			else
				strRTF = "\plain" & strStyle & " " & strRTF
			end if
      

	  If len( strRTF ) > 0 Then
	    strRTF = "{" & strRTF & "}"
	  End If

		  reduceRTF2 = strRTF
End Function
' --------------------------------------------------------------------

function IsRtf(str)

	if left(str, 5) = "{\rtf" then
		IsRtf = true
	else
		IsRtf = false
	end if

end function
'--------------------------------------------------------------------

Function reduceRTF3( r )
	Set re = New RegExp
      
	
	re.MultiLine  = False
      	re.IgnoreCase = False
      	re.Global     = True

	
      	strRTF = reduceRTF1( r, true )   ' change to false as soon as font sizes are exported

        reduceRTF3 = strRTF
End Function
' --------------------------------------------------------------------

    ' --------------------------------------------------------------------
Function reduceRTF4 ( r )
    Set re = New RegExp

    re.MultiLine  = False
    re.IgnoreCase = False
    re.Global     = True

	    ' remove lin
  	  're.Pattern = "\\li(?![a-z0-9])"
    	re.Pattern = "\\lin?[0-9]+"

			strRTF = re.Replace( reduceRTF1(r, true),"")
		
	  	If len( strRTF ) > 0 Then
      	re.Pattern = "\\plain(\s+)"
		    strRTF = re.Replace(strRTF ,"\plain \fs20 ")
		  	'strRTF = "{" & strRTF & "}"
			End If

    If len( strRTF ) > 0 Then
			strRTF = "{" & LTrim(strRTF) & "}"			
		End If

    reduceRTF4 = strRTF ' change to false as soon as font sizes are exported
End Function



    ' --------------------------------------------------------------------
		Function HexToDec ( strHex )
		  dim lngResult
		  dim intIndex
		  dim strDigit
		  dim intDigit
		  dim intValue

		  lngResult = 0
		  
		  For intIndex = len( strHex ) To 1 Step -1
		    strDigit = mid( strHex, intIndex, 1 )
		    intDigit = instr( "0123456789ABCDEF", ucase( strDigit ) )-1
		    
		    If intDigit >= 0 Then
		      intValue  = intDigit * ( 16 ^ ( len( strHex ) - intIndex ) )
		      lngResult = lngResult + intValue
		    Else
		      lngResult = 0
		      intIndex  = 0 ' stop the loop
		    End If
		  Next

		  HexToDec = lngResult
		End Function
    ' --------------------------------------------------------------------
    
    
    
    ' --------------------------------------------------------------------
		Function HexToChr ( strHex )
		  HexToChr = Chr( HexToDec( strHex ) )
		End Function
    ' --------------------------------------------------------------------
    
    
    
    ' --------------------------------------------------------------------
    Function rtfChars2PlainText ( r )
      Set re = New RegExp

      re.MultiLine  = False
      re.IgnoreCase = False
      re.Global     = True

      re.Pattern = "\\\'(00)"
      r = re.Replace( r, HexToChr( "00" ) )
      re.Pattern = "\\\'(a9)"
      r = re.Replace( r, HexToChr( "a9" ) )
      re.Pattern = "\\\'(b4)"
      r = re.Replace( r, HexToChr( "b4" ) )
      re.Pattern = "\\\'(ab)"
      r = re.Replace( r, HexToChr( "ab" ) )
      re.Pattern = "\\\'(bb)"
      r = re.Replace( r, HexToChr( "bb" ) )
      re.Pattern = "\\\'(a1)"
      r = re.Replace( r, HexToChr( "a1" ) )
      re.Pattern = "\\\'(bf)"
      r = re.Replace( r, HexToChr( "bf" ) )
      re.Pattern = "\\\'(c0)"
      r = re.Replace( r, HexToChr( "c0" ) )
      re.Pattern = "\\\'(e0)"
      r = re.Replace( r, HexToChr( "e0" ) )
      re.Pattern = "\\\'(c1)"
      r = re.Replace( r, HexToChr( "c1" ) )
      re.Pattern = "\\\'(e1)"
      r = re.Replace( r, HexToChr( "e1" ) )   'á
      re.Pattern = "\\\'(c2)"
      r = re.Replace( r, HexToChr( "c2" ) )
      re.Pattern = "\\\'(e2)"
      r = re.Replace( r, HexToChr( "e2" ) )
      re.Pattern = "\\\'(c3)"
      r = re.Replace( r, HexToChr( "c3" ) )
      re.Pattern = "\\\'(e3)"
      r = re.Replace( r, HexToChr( "e3" ) )
      re.Pattern = "\\\'(c4)"
      r = re.Replace( r, HexToChr( "c4" ) )
      re.Pattern = "\\\'(e4)"
      r = re.Replace( r, HexToChr( "e4" ) )
      re.Pattern = "\\\'(99)"
      r = re.Replace( r, "<SUP>TM</SUP>" )
      re.Pattern = "\\\'(c5)"
      r = re.Replace( r, HexToChr( "c5" ) )
      re.Pattern = "\\\'(e5)"
      r = re.Replace( r, HexToChr( "e5" ) )
      re.Pattern = "\\\'(c6)"
      r = re.Replace( r, HexToChr( "c6" ) )
      re.Pattern = "\\\'(e6)"
      r = re.Replace( r, HexToChr( "e6" ) )
      re.Pattern = "\\\'(c7)"
      r = re.Replace( r, HexToChr( "c7" ) )
      re.Pattern = "\\\'(e7)"
      r = re.Replace( r, HexToChr( "e7" ) )
      re.Pattern = "\\\'(d0)"
      r = re.Replace( r, HexToChr( "d0" ) )
      re.Pattern = "\\\'(f0)"
      r = re.Replace( r, HexToChr( "f0" ) )
      re.Pattern = "\\\'(c8)"
      r = re.Replace( r, HexToChr( "c8" ) )
      re.Pattern = "\\\'(e8)"
      r = re.Replace( r, HexToChr( "e8" ) )
      re.Pattern = "\\\'(c9)"
      r = re.Replace( r, HexToChr( "c9" ) )
      re.Pattern = "\\\'(e9)"
      r = re.Replace( r, HexToChr( "e9" ) )
      re.Pattern = "\\\'(ca)"
      r = re.Replace( r, HexToChr( "ca" ) )
      re.Pattern = "\\\'(ea)"
      r = re.Replace( r, HexToChr( "ea" ) )
      re.Pattern = "\\\'(cb)"
      r = re.Replace( r, HexToChr( "cb" ) )
      re.Pattern = "\\\'(eb)"
      r = re.Replace( r, HexToChr( "eb" ) )
      re.Pattern = "\\\'(cc)"
      r = re.Replace( r, HexToChr( "cc" ) )
      re.Pattern = "\\\'(ec)"
      r = re.Replace( r, HexToChr( "ec" ) )
      re.Pattern = "\\\'(cd)"
      r = re.Replace( r, HexToChr( "cd" ) )
      re.Pattern = "\\\'(ed)"
      r = re.Replace( r, HexToChr( "ed" ) )   'í
      re.Pattern = "\\\'(ce)"
      r = re.Replace( r, HexToChr( "ce" ) )
      re.Pattern = "\\\'(ee)"
      r = re.Replace( r, HexToChr( "ee" ) )
      re.Pattern = "\\\'(cf)"
      r = re.Replace( r, HexToChr( "cf" ) )
      re.Pattern = "\\\'(ef)"
      r = re.Replace( r, HexToChr( "ef" ) )
      re.Pattern = "\\\'(d1)"
      r = re.Replace( r, HexToChr( "d1" ) )
      re.Pattern = "\\\'(f1)"
      r = re.Replace( r, HexToChr( "f1" ) )
      re.Pattern = "\\\'(d2)"
      r = re.Replace( r, HexToChr( "d2" ) )
      re.Pattern = "\\\'(f2)"
      r = re.Replace( r, HexToChr( "f2" ) )
      re.Pattern = "\\\'(d3)"
      r = re.Replace( r, HexToChr( "d3" ) )
      re.Pattern = "\\\'(f3)"
      r = re.Replace( r, HexToChr( "f3" ) )
      re.Pattern = "\\\'(d4)"
      r = re.Replace( r, HexToChr( "d4" ) )
      re.Pattern = "\\\'(f4)"
      r = re.Replace( r, HexToChr( "f4" ) )
      re.Pattern = "\\\'(d5)"
      r = re.Replace( r, HexToChr( "d5" ) )
      re.Pattern = "\\\'(f5)"
      r = re.Replace( r, HexToChr( "f5" ) )
      re.Pattern = "\\\'(d6)"
      r = re.Replace( r, HexToChr( "d6" ) )
      re.Pattern = "\\\'(f6)"
      r = re.Replace( r, HexToChr( "f6" ) )
      re.Pattern = "\\\'(d8)"
      r = re.Replace( r, HexToChr( "d8" ) )
      re.Pattern = "\\\'(f8)"
      r = re.Replace( r, HexToChr( "f8" ) )
      re.Pattern = "\\\'(d9)"
      r = re.Replace( r, HexToChr( "d9" ) )
      re.Pattern = "\\\'(f9)"
      r = re.Replace( r, HexToChr( "f9" ) )
      re.Pattern = "\\\'(da)"
      r = re.Replace( r, HexToChr( "da" ) )
      re.Pattern = "\\\'(fa)"
      r = re.Replace( r, HexToChr( "fa" ) )
      re.Pattern = "\\\'(db)"
      r = re.Replace( r, HexToChr( "db" ) )
      re.Pattern = "\\\'(fb)"
      r = re.Replace( r, HexToChr( "fb" ) )
      re.Pattern = "\\\'(dc)"
      r = re.Replace( r, HexToChr( "dc" ) )
      re.Pattern = "\\\'(fc)"
      r = re.Replace( r, HexToChr( "fc" ) )
      re.Pattern = "\\\'(dd)"
      r = re.Replace( r, HexToChr( "dd" ) )
      re.Pattern = "\\\'(fd)"
      r = re.Replace( r, HexToChr( "fd" ) )
      re.Pattern = "\\\'(ff)"
      r = re.Replace( r, HexToChr( "ff" ) )
      re.Pattern = "\\\'(de)"
      r = re.Replace( r, HexToChr( "de" ) )
      re.Pattern = "\\\'(fe)"
      r = re.Replace( r, HexToChr( "fe" ) )
      re.Pattern = "\\\'(df)"
      r = re.Replace( r, HexToChr( "df" ) )
      re.Pattern = "\\\'(a7)"
      r = re.Replace( r, HexToChr( "a7" ) )
      re.Pattern = "\\\'(b6)"
      r = re.Replace( r, HexToChr( "b6" ) )
      re.Pattern = "\\\'(b5)"
      r = re.Replace( r, HexToChr( "b5" ) )
      re.Pattern = "\\\'(a6)"
      r = re.Replace( r, HexToChr( "a6" ) )
      re.Pattern = "\\\'(b1)"
      r = re.Replace( r, HexToChr( "b1" ) )
      re.Pattern = "\\\'(b7)"
      r = re.Replace( r, HexToChr( "b7" ) )
      re.Pattern = "\\\'(a8)"
      r = re.Replace( r, HexToChr( "a8" ) )
      re.Pattern = "\\\'(b8)"
      r = re.Replace( r, HexToChr( "b8" ) )
      re.Pattern = "\\\'(aa)"
      r = re.Replace( r, HexToChr( "aa" ) )
      re.Pattern = "\\\'(ba)"
      r = re.Replace( r, HexToChr( "ba" ) )
      re.Pattern = "\\\'(ac)"
      r = re.Replace( r, HexToChr( "ac" ) )
      re.Pattern = "\\\'(ad)"
      r = re.Replace( r, HexToChr( "ad" ) )
      re.Pattern = "\\\'(af)"
      r = re.Replace( r, HexToChr( "af" ) )
      re.Pattern = "\\\'(b0)"
      r = re.Replace( r, HexToChr( "b0" ) )
      re.Pattern = "\\\'(b9)"
      r = re.Replace( r, HexToChr( "b9" ) )
      re.Pattern = "\\\'(b2)"
      r = re.Replace( r, HexToChr( "b2" ) )
      re.Pattern = "\\\'(b3)"
      r = re.Replace( r, HexToChr( "b3" ) )
      re.Pattern = "\\\'(bc)"
      r = re.Replace( r, HexToChr( "bc" ) )
      re.Pattern = "\\\'(bd)"
      r = re.Replace( r, HexToChr( "bd" ) )
      re.Pattern = "\\\'(be)"
      r = re.Replace( r, HexToChr( "be" ) )
      re.Pattern = "\\\'(d7)"
      r = re.Replace( r, HexToChr( "d7" ) )
      re.Pattern = "\\\'(f7)"
      r = re.Replace( r, HexToChr( "f7" ) )
      re.Pattern = "\\\'(a2)"
      r = re.Replace( r, HexToChr( "a2" ) )
      re.Pattern = "\\\'(a3)"
      r = re.Replace( r, HexToChr( "a3" ) )
      re.Pattern = "\\\'(a4)"
      r = re.Replace( r, HexToChr( "a4" ) )
      re.Pattern = "\\\'(a5)"
      r = re.Replace( r, HexToChr( "a5" ) )
      re.Pattern = "\\\'(85)"
      r = re.Replace( r, "..." )
      re.Pattern = "\\\'(9e)"
      r = re.Replace( r, "_" )   '_
      re.Pattern = "\\\'(9a)"
      r = re.Replace( r, "_" )   '_

      ' remove unrecognized chars
      re.Pattern = "\\\'[a-zA-Z0-9]{2}"
      r = re.Replace( r, "" )   '_

      rtfChars2PlainText = r
    End Function
    ' --------------------------------------------------------------------
    
    
    
    ' --------------------------------------------------------------------
		Function removeRTF ( r )
      ' remove header
      r = reduceRTF ( r )
     r = rtfChars2PlainText ( r )
      Set re = New RegExp

      re.MultiLine  = False
      re.IgnoreCase = False
      re.Global     = True

      ' save normal brackets and backslashes
      re.Pattern = "\\\\"
      r = re.Replace( r, "/BACKSLASH/" )
      re.Pattern = "\\\{"
      r = re.Replace( r, "/BRACKET_OPEN/" )
      re.Pattern = "\\\}"
      r = re.Replace( r, "/BRACKET_CLOSE/" )

	      ' convert line breaks
	      re.Pattern = "\\par[^d]"
	      'Alte Version - wurde aufgrund der Tatsache, dass aus den Einzelplatzrechnern häufiger Daten in die Netzwerk Version übernommen werden
	      'r = re.Replace( r, "<br/>" )
			'statt dessen wird ein Leerzeichen statt eines Zeilenumbruches eingefügt
			r = re.Replace( r, " " )
	      
	      re.Pattern = "\{\\field{"
	      r = re.Replace(r, "/hyperlink_open") 

	     re.Pattern = "\}\}"
	     r = re.Replace(r, "/hyperlink_close")
	      	     
	      ' remove rtf-grouping brackets
	       re.Pattern = "[\{\}]"
	       r = re.Replace( r, "" )
		

	      ' remove rtf-commands
	      re.Pattern = "\\(\*|[a-zA-Z]+-?[0-9]*)"
	      r = re.Replace( r, "" )

      ' restore normal brackets and backslashes
      re.Pattern = "/BRACKET_CLOSE/"
      r = re.Replace( r, "\}" )
      re.Pattern = "/BRACKET_OPEN/"
      r = re.Replace( r, "\{" )
      re.Pattern = "/BACKSLASH/"
      r = re.Replace( r, "\\" )
      
      	      re.Pattern = "/hyperlink_open "
	      r = re.Replace(r, "{")
	      
      	      re.Pattern = "/hyperlink_close"
	      r = re.Replace(r, "}")
       
      'added by NMA(23.01.04) to ensure normalized whitespaces in a dataexport without RTF Elements
      ' normalize multiple whitespaces
      re.Pattern = "\s+"
      r = re.Replace( r, " " )
      ' remove leading and trailing whitespaces
      re.Pattern = "^\s+|\s+$"
      r = re.Replace( r, "" )
      
      re.Pattern = "\"""
      r = re.Replace( r, "" )
      
      removeRTF = r
      End Function
    ' --------------------------------------------------------------------



    ' --------------------------------------------------------------------
		Function removeRTF2 ( bol, r )
		  If bol = "yes" and InStr( r, "\rtf1" ) <> 0 Then
		    removeRTF2 = removeRTF( r )
		  Else
		    removeRTF2 = r
		  End If
    End Function
    ' --------------------------------------------------------------------



		' ====================================================================
		' Konvertieren nach HTML =============================================
		' ====================================================================



		' --------------------------------------------------------------------
'
'
'
' Es scheint in diesem Skript einen grundsätzlichen Fehler bei verschachtelten Formatierungen zu geben,
' der nur deshalb nicht ins Gewicht fällt, weil die Browser sehr tollerant sind.
' \i \b TEST \b0 \i0 wird zu <i> <b> TEST </i> </b> anstatt zu <i> <b> TEST </b> </i>
'
'
'		
' che: changed on 2003-03-28
' che: changed on 2003-04-01   line breaks did not work the way they should
' che: changed on 2003-04-14   lists did not work correctly

' che: "As ..." removed
' che: "GoTo finnaly" and "finally:" replaced by "If Then"
' che: many other replacements

' che: types are not supported in vbscript
' che Private Type CodeList
' che   Code
' che   Status                         'P=Pending;A=Active;G=Paragraph;D=Dead;K=Killed
' che                                  '"Dead" means the code is active but will be killed at next text
' che                                  '"Pending" means it's waiting for text - if the code is canceled before text appears it will be killed
' che                                  '"Active" means there is text using the code at this moment
' che                                  '"Paragraph" means that the code stays active until the next paragraph: "/pard" or "/pntext"
' che End Type
' che: a 2-d-array will be used instead
' che: first dimension will be for code and status, second for values,
' che: because redim is used for values and only last dimension can be redimed
' che: constants for accessing 2nd dimension of array
' che - Begin
		Const CODE   = 1
		Const STATUS = 2
' che - End

		Public strCurPhrase
		Dim strHTML
		Public Codes()
		Public CodesBeg()                  'beginning codes
		Public NextCodes()
		Public NextCodesBeg()              'beginning codes for next text
		Dim CodesTmp()                     'temp stack for copying
		Dim CodesTmpBeg()                  'temp stack for copying beg

		Public strCR                       'string to use for CRs - blank if +CR not chosen in options
		Dim strBeforeText
		Dim strBeforeText2
		Dim strBeforeText3
		Dim gPlain                         'true if all codes shouls be popped before next text
		Dim gWBPlain                       'plain will be true after next text
		Dim strColorTable(0)               'table of colors
		Dim lColors                        '# of colors
		Dim strEOL                         'string to include before <br>
		Dim strBOL                         'string to include after <br>
		Dim lSkipWords                     'number od words to skip from current
		Dim gBOL                           'a <br> was inserted but no non-whitespace text has been inserted
		Dim gPar                           'true if paragraph was reached since last text
		Dim lBrLev                         'bracket level when finding matching brackets
		Dim strSecTmp                      'temporary section buffer
		Dim gIgnorePard                    'should pard end list items or not?

		Dim strFontTable(0)                'table of fonts
		Dim lFonts                         '# of fonts
		Dim strFont
		Dim strTable
		Dim strFace                        'current font face for setting up fontstring
		Dim strFontColor                   'current font color for setting up fontstring
		Dim strFontSize                    'current font size for setting up fontstring
		Dim lFontSize
		Dim iDefFontSize                   'default font size
		Dim gUseFontFace                   'use different fonts or always use default font

		Public gDebug                      'for debugging
		Public gStep                       'for debugging
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function rtf2html3 ( strRTF )   ' che , Optional strOptions )
		    'Version 3.02
		    'Copyright Brady Hegberg 2000
		    '  I'm not licensing this software but I'd appreciate it if
		    '  you'd to consider it to be under an lgpl sort of license

		    'More information can be found at
		    'http://www2.bitstream.net/~bradyh/downloads/rtf2htmlrm.html

		    'Converts Rich Text encoded text to HTML format
		    'if you find some text that this function doesn't
		    'convert properly please email the text to
		    'bradyh@bitstream.net

		    'Options:
		    '+H              add an HTML header and footer
		    '+G              add a generator Metatag
		    '+T="MyTitle"    add a title (only works if +H is used)
		    '+CR             add a carraige return after all <br>s
		    '+I              keep html codes intact
		    '+F=X            default font size (blanks out any changes to this size - saves on space)
		    '-FF             ignore font faces

		    Dim strHTML
		    Dim strRTFTmp
		    Dim l
		    Dim lTmp
		    Dim lTmp2
		    Dim lTmp3
		    Dim lRTFLen
		    Dim lBOS                         'beginning of section
		    Dim lEOS                         'end of section
		    Dim strTmp
		    Dim strTmp2
		    Dim strEOS                       'string to be added to end of section
		    Dim strBOS                       'string to be added to beginning of section
		    Dim strEOP                       'string to be added to end of paragraph
		    Dim strBOL                       'string to be added to the begining of each new line
		    Dim strEOL                       'string to be added to the end of each new line
		    Dim strEOLL                      'string to be added to the end of previous line
		    Const gHellFrozenOver = False    'always false
		    Dim gSkip                        'skip to next word/command
		    Dim strCodes                     'codes for ascii to HTML char conversion
		    Dim strCurLine                   'temp storage for text for current line before being added to strHTML
		    Dim strFontCodes                 'list of font code modifiers
		    Dim gSeekingText                 'True if we have to hit text before inserting a </FONT>
		    Dim gText                        'true if there is text (as opposed to a control code) in strTmp
		    Dim strAlign                     '"center" or "right"
		    Dim gAlign                       'if current text is aligned
		    Dim strGen                       'Temp store for Generator Meta Tag if requested
		    Dim strTitle                     'Temp store for Title if requested
		    Dim gHTML                        'true if html codes should be left intact
		    Dim strWordTmp                   'temporary word buffer
		    Dim strEndText                   'ending text

		    ClearCodes
		    strHTML = ""
		    gPlain = False
		    gBOL = True
		    gPar = False
		    strCurPhrase = ""

		    'setup +CR option
		    If InStr(strOptions, "+CR") <> 0 Then strCR = vbCrLf Else strCR = ""
		    'setup +HTML option
		    If InStr(strOptions, "+I") <> 0 Then gHTML = True Else gHTML = False
		    'setup default font size option
		    If InStr(strOptions, "+F=") <> 0 Then
		        l = InStr(strOptions, "+F=") + 3
		        strTmp = Mid(strOptions, l, 1)
		        iDefFontSize = 0
		        While IsDig(strTmp)
		            iDefFontSize = iDefFontSize * 10 + (strTmp)
		            l = l + 1
		            strTmp = Mid(strOptions, l, 1)
		        Wend
		    End If
		    'setup to use different fonts or not
		    If InStr(strOptions, "-FF") <> 0 Then gUseFontFace = False Else gUseFontFace = True

		    strRTFTmp = TrimAll(strRTF)

		    If Left(strRTFTmp, 1) = "{" And Right(strRTFTmp, 1) = "}" Then strRTFTmp = Mid(strRTFTmp, 2, Len(strRTFTmp) - 2)

		    'setup list (bullets) status
		    If InStr(strRTFTmp, "\list\") <> 0 Then
		        'I'm not sure if this is in any way correct but it seems to work for me
		        'sometimes \pard ends a list item sometimes it doesn't
		        gIgnorePard = True
		    Else
		        gIgnorePard = False
		    End If

		    'setup color table
		    lBOS = InStr(strRTFTmp, "\colortbl")
		    If lBOS > 0 Then
		        strSecTmp = NabSection(strRTFTmp, lBOS)
' che: ignore colortable for now
' che       GetColorTable strSecTmp, strColorTable()
		    End If

		    'setup font table
		    lBOS = InStr(strRTFTmp, "\fonttbl")
		    If lBOS > 0 Then
		        strSecTmp = NabSection(strRTFTmp, lBOS)
' che: ignore fonttable for now
' che       GetFontTable strSecTmp, strFontTable()
		    End If

		    'setup stylesheets
		    lBOS = InStr(strRTFTmp, "\stylesheet")
		    If lBOS > 0 Then
		        strSecTmp = NabSection(strRTFTmp, lBOS)
		        'ignore stylesheets for now
		    End If

		    'setup info
		    lBOS = InStr(strRTFTmp, "\info")
		    If lBOS > 0 Then
		        strSecTmp = NabSection(strRTFTmp, lBOS)
		        'ignore info for now
		    End If

		    'list table
		    lBOS = InStr(strRTFTmp, "\listtable")
		    If lBOS > 0 Then
		        strSecTmp = NabSection(strRTFTmp, lBOS)
		        'ignore info for now
		    End If

		    'list override table
		    lBOS = InStr(strRTFTmp, "\listoverridetable")
		    If lBOS > 0 Then
		        strSecTmp = NabSection(strRTFTmp, lBOS)
		        'ignore info for now
		    End If

' che: replace \par by <br/>, otherwise they seem to be ignored for some reason
' che - Begin
		    Dim re

		    Set re = New RegExp

		    re.Pattern    = "\\par([\s\\\{\}])"
				re.Global     = True
				re.IgnoreCase = True
				re.MultiLine  = True

				strRTFTmp = re.Replace( strRTFTmp, "<br/>$1" )
' che - End

		    lBrLev = 0
		    While Len(strRTFTmp) > 0
		        strSecTmp = NabNextLine(strRTFTmp)
		        While Len(strSecTmp) > 0
		            strWordTmp = NabNextWord(strSecTmp)
		            If lBrLev > 0 Then
		                If strWordTmp = "{" Then
		                    lBrLev = lBrLev + 1
		                ElseIf strWordTmp = "}" Then
		                    lBrLev = lBrLev - 1
		                End If
		                strWordTmp = ""
		            ElseIf strWordTmp = "\*" Or strWordTmp = "\pict" Then
		                'skip \pnlvlbt stuff
		                lBrLev = 1
		                strWordTmp = ""
		            ElseIf strWordTmp = "\pntext" Then
		                'get bullet codes but skip rest for now
		                lBrLev = 1
		            End If
		            If Len(strWordTmp) > 0 Then
		                If gDebug Then ShowCodes (strWordTmp)  'for debugging only
		                If Len(strWordTmp) > 0 Then ProcessWord strWordTmp
		            End If
		        Wend
		    Wend

		    'get any remaining codes in stack
		    strEndText = strEndText & GetActiveCodes
		    strBeforeText2 = rtf2html_replace(strBeforeText2, "<br>", "")
		    strBeforeText2 = rtf2html_replace(strBeforeText2, vbCrLf, "")
		    strCurPhrase = strCurPhrase & strBeforeText & strBeforeText2 & strEndText
		    strBeforeText = ""
		    strBeforeText2 = ""
		    strBeforeText3 = ""
		    strHTML = strHTML & strCurPhrase
		    strCurPhrase = ""
		    ClearFont

' che: replace 'vbNewLine's
' che - Begin
		    Set re = New RegExp

		    re.Pattern    = "\n?<br\/?>"
				re.Global     = True
				re.IgnoreCase = True
				re.MultiLine  = True

				strHTML = re.Replace( strHTML, "<br/>" )

		    Set re = New RegExp

		    re.Pattern    = "\n"
				re.Global     = True
				re.IgnoreCase = True
				re.MultiLine  = True

				strHTML = re.Replace( strHTML, "<br/>" )
' che - End

		    rtf2html3 = strHTML
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ClearCodes ()
		    ReDim Codes(2,0)
		    ReDim CodesBeg(2,0)
		    ClearNext ""
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		' che: clear NextCodes-List completely if no strExcept is defined,
		' che: otherwise remove those items only which do not match strExcept
		Function ClearNext ( strExcept )
		    Dim l
		    Dim finally

		    finally = False
		    
		    If Len( strExcept ) > 0 Then
		        If InNext( strExcept ) Then
		            While NextCodes( 1 ) <> strExcept
		                ShiftNext
		                ShiftNextBeg
		            Wend
		            
		            finally = True
		        End If
		    End If

		    If Not finally Then
		      ReDim NextCodes(0)
		      ReDim NextCodesBeg(0)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		' che: clear current font settings
		Function ClearFont ()
		    strFont = ""
		    strTable = ""
		    strFontColor = ""
		    strFace = ""
		    strFontSize = ""
		    lFontSize = 0
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function Codes2NextTill ( strCode )
		    Dim strTmp
		    Dim strTmpbeg
		    Dim l

		    For l = 1 To UBound( Codes, 2 )
		        If Codes( CODE, l ) = strCode Then Exit For
		        
' che: changed Codes( CODE, l ) <> "K" to Codes( STATUS, l ) <> "K"
		        If Codes( STATUS, l ) <> "K" And Codes( STATUS, l ) <> "D" Then
		            If Not InNext( strCode ) Then
		                UnShiftNext ( Codes( CODE, l) )
		                UnShiftNextBeg ( CodesBeg( CODE, l) )
		            End If
		        End If
		    Next
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetColorTable( strSecTmp , strColorTable() )
		    'get color table data and fill in strColorTable array
		    Dim lColors
		    Dim lBOS
		    Dim lEOS
		    Dim strTmp

		    lBOS = InStr(strSecTmp, "\colortbl")
		    ReDim strColorTable(0)
		    lColors = 1
		    If lBOS <> 0 Then
		        lBOS = InStr(lBOS, strSecTmp, ";")
		        lEOS = InStr(lBOS, strSecTmp, ";}")
		        If lEOS <> 0 Then
		            lBOS = InStr(lBOS, strSecTmp, "\red")
		            While ((lBOS <= lEOS) And (lBOS <> 0))
		                ReDim Preserve strColorTable(lColors)
		                strTmp = Trim(Hex(Mid(strSecTmp, lBOS + 4, 1) & IIf(IsNumeric(Mid(strSecTmp, lBOS + 5, 1)), Mid(strSecTmp, lBOS + 5, 1), "") & IIf(IsNumeric(Mid(strSecTmp, lBOS + 6, 1)), Mid(strSecTmp, lBOS + 6, 1), "")))
		                If Len(strTmp) = 1 Then strTmp = "0" & strTmp
		                strColorTable(lColors) = strColorTable(lColors) & strTmp
		                lBOS = InStr(lBOS, strSecTmp, "\green")
		                strTmp = Trim(Hex(Mid(strSecTmp, lBOS + 6, 1) & IIf(IsNumeric(Mid(strSecTmp, lBOS + 7, 1)), Mid(strSecTmp, lBOS + 7, 1), "") & IIf(IsNumeric(Mid(strSecTmp, lBOS + 8, 1)), Mid(strSecTmp, lBOS + 8, 1), "")))
		                If Len(strTmp) = 1 Then strTmp = "0" & strTmp
		                strColorTable(lColors) = strColorTable(lColors) & strTmp
		                lBOS = InStr(lBOS, strSecTmp, "\blue")
		                strTmp = Trim(Hex(Mid(strSecTmp, lBOS + 5, 1) & IIf(IsNumeric(Mid(strSecTmp, lBOS + 6, 1)), Mid(strSecTmp, lBOS + 6, 1), "") & IIf(IsNumeric(Mid(strSecTmp, lBOS + 7, 1)), Mid(strSecTmp, lBOS + 7, 1), "")))
		                If Len(strTmp) = 1 Then strTmp = "0" & strTmp
		                strColorTable(lColors) = strColorTable(lColors) & strTmp
		                lBOS = InStr(lBOS, strSecTmp, "\red")
		                lColors = lColors + 1
		            Wend
		        End If
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetFontTable( strSecTmp , strFontTable() )
		    'get font table data and fill in strFontTable array
		    Dim lFonts
		    Dim lBOS
		    Dim lEOS
		    Dim strTmp
		    Dim lLvl
		    Dim strNextChar

		    lBOS = InStr(strSecTmp, "\fonttbl")
		    ReDim strFontTable(0)
		    lFonts = 0
		    If lBOS <> 0 Then
		        lEOS = InStr(lBOS, strSecTmp, ";}}")
		        If lEOS <> 0 Then
		            lBOS = InStr(lBOS, strSecTmp, "\f0")
		            While ((lBOS <= lEOS) And (lBOS <> 0))
		                ReDim Preserve strFontTable(lFonts)
		                strNextChar = Mid(strSecTmp, lBOS, 1)
		                While (((strNextChar <> " ") And (lBOS <= lEOS)) Or (lLvl > 0))
		                    lBOS = lBOS + 1
		                    If strNextChar = "{" Then
		                        lLvl = lLvl + 1
		                        strNextChar = Mid(strSecTmp, lBOS, 1)
		                    ElseIf strNextChar = "}" Then
		                        lLvl = lLvl - 1
		                        If lLvl = 0 Then
		                            strNextChar = " "
		                            lBOS = lBOS - 1
		                        Else
		                            strNextChar = Mid(strSecTmp, lBOS, 1)
		                        End If
		                    Else
		                        strNextChar = Mid(strSecTmp, lBOS, 1)
		                    End If
		                Wend
		                lBOS = lBOS + 1
		                strTmp = Mid(strSecTmp, lBOS, InStr(lBOS, strSecTmp, ";") - lBOS)
		                strFontTable(lFonts) = strFontTable(lFonts) & strTmp
		                lBOS = InStr(lBOS, strSecTmp, "\f" & (lFonts + 1))
		                lFonts = lFonts + 1
		            Wend
		        End If
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function InNext ( strTmp )
		    Dim gTmp
		    Dim l

		    l = 1
		    gTmp = False
		    While l <= UBound(NextCodes) And Not gTmp
		        If NextCodes(l) = strTmp Then gTmp = True
		        l = l + 1
		    Wend
		    InNext = gTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function InNextBeg ( strTmp )
		    Dim gTmp
		    Dim l

		    l = 1
		    gTmp = False
		    While l <= UBound(NextCodesBeg) And Not gTmp
		        If NextCodesBeg(l) = strTmp Then gTmp = True
		        l = l + 1
		    Wend
		    InNextBeg = gTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function InCodes ( strTmp, gActiveOnly )   ' che: gActiveOnly should be optional and would then be false by default
		    Dim gTmp
		    Dim l

		    l = 1
		    gTmp = False
		    
		    While l <= UBound( Codes, 2 ) And Not gTmp
		        If gActiveOnly Then
		            If Codes( CODE, l ) = strTmp And ( Codes( STATUS, l ) = "A" Or Codes( STATUS, l ) = "G" ) Then gTmp = True
		        Else
		            If Codes( CODE, l ) = strTmp Then gTmp = True
		        End If
		        
		        l = l + 1
		    Wend
		    
		    InCodes = gTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function InCodesBeg ( strTmp )
		    Dim gTmp
		    Dim l

		    l = 1
		    gTmp = False
		    While l <= UBound(CodesBeg,2) And Not gTmp
		        If CodesBeg(CODE,l) = strTmp Then gTmp = True
		        l = l + 1
		    Wend
		    InCodesBeg = gTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function NabNextLine ( strRTF )
		    Dim l

		    l = InStr(strRTF, vbCrLf)
		    If l = 0 Then l = Len(strRTF)
		    NabNextLine = TrimAll(Left(strRTF, l))
		    If l = Len(strRTF) Then
		        strRTF = ""
		    Else
		        strRTF = TrimAll(Mid(strRTF, l))
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function NabNextWord ( strLine )
		    Dim l
		    Dim lvl
		    Dim gEndofWord
		    Dim gInCommand               'current word is command instead of plain word
		    Dim finally

		    finally = False
		    gInCommand = False
		    l = 0
		    lvl = 0
		    'strLine = TrimifCmd(strLine)
		    If Left(strLine, 1) = "}" Then
		        strLine = Mid(strLine, 2)
		        NabNextWord = "}"
		        finally = True
		    End If
		    If Not finally Then
			    If Left(strLine, 1) = "{" Then
			        strLine = Mid(strLine, 2)
			        NabNextWord = "{"
			        finally = True
			    End If
			    If Not finally Then
				    If Left(strLine, 2) = "\'" Then
				        NabNextWord = Left(strLine, 4)
				        strLine = Mid(strLine, 5)
				        finally = True
				    End If
			      If Not finally Then
					    While Not gEndofWord
					        l = l + 1
					        If l >= Len(strLine) Then
					            If l = Len(strLine) Then l = l + 1
					            gEndofWord = True
					        ElseIf InStr("\{}", Mid(strLine, l, 1)) Then
					            If l = 1 And Mid(strLine, l, 1) = "\" Then gInCommand = True
					            If Mid(strLine, l + 1, 1) <> "\" And l > 1 And lvl = 0 Then
					                gEndofWord = True
					            End If
					        ElseIf Mid(strLine, l, 1) = " " And lvl = 0 And gInCommand Then
					            gEndofWord = True
					        End If
					    Wend

					    If l = 0 Then l = Len(strLine)
					    NabNextWord = Left(strLine, l - 1)
					    While Len(NabNextWord) > 0 And InStr("{}", Right(NabNextWord, 1)) And l > 0
					        NabNextWord = Left(NabNextWord, Len(NabNextWord) - 1)
					        l = l - 1
					    Wend
					    strLine = Mid(strLine, l)
					    If Left(strLine, 1) = " " Then strLine = Mid(strLine, 2)
			  	  End If
				  End If
			  End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function NabSection ( strRTF , lPos )
		    'grab section surrounding lPos, strip section out of strRTF and return it
		    Dim lBOS                 'beginning of section
		    Dim lEOS                 'ending of section
		    Dim strChar
		    Dim lLev                 'level of brackets/parens
		    Dim lRTFLen

		    lRTFLen = Len(strRTF)

		    lBOS = lPos
		    strChar = Mid(strRTF, lBOS, 1)
		    lLev = 1
		    While lLev > 0
		        lBOS = lBOS - 1
		        If lBOS <= 0 Then
		            lLev = lLev - 1
		        Else
		            strChar = Mid(strRTF, lBOS, 1)
		            If strChar = "}" Then
		                lLev = lLev + 1
		            ElseIf strChar = "{" Then
		                lLev = lLev - 1
		            End If
		        End If
		    Wend
		    lBOS = lBOS - 1
		    If lBOS < 1 Then lBOS = 1

		    lEOS = lPos
		    strChar = Mid(strRTF, lEOS, 1)
		    lLev = 1
		    While lLev > 0
		        lEOS = lEOS + 1
		        If lEOS >= lRTFLen Then
		            lLev = lLev - 1
		        Else
		            strChar = Mid(strRTF, lEOS, 1)
		            If strChar = "{" Then
		                lLev = lLev + 1
		            ElseIf strChar = "}" Then
		                lLev = lLev - 1
		            End If
		        End If
		    Wend
		    lEOS = lEOS + 1
		    If lEOS > lRTFLen Then lEOS = lRTFLen
		    NabSection = Mid(strRTF, lBOS + 1, lEOS - lBOS - 1)
		    strRTF = Mid(strRTF, 1, lBOS) & Mid(strRTF, lEOS)
		    strRTF = rtf2html_replace(strRTF, vbCrLf & vbCrLf, vbCrLf)
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function Next2Codes ()
		    'move codes from pending ("next") stack to front of current stack
		    Dim lNumCodes
		    Dim lNumNext
		    Dim l

		    If UBound(NextCodes) > 0 Then
 		        If InNext("</li>") Then
 		            For l = UBound(NextCodes) To 1 Step -1
 		                If NextCodes(l) = "</li>" And l > 1 Then
 		                    NextCodes(l) = NextCodes(l - 1)
 		                    NextCodesBeg(l) = NextCodesBeg(l - 1)
 		                    NextCodes(l - 1) = "</li>"
 		                    NextCodesBeg(l - 1) = "<li>"
 		                End If
 		            Next
		        End If

		        lNumCodes = UBound(Codes,2)
		        lNumNext = UBound(NextCodes)
		        ReDim Preserve Codes(2,lNumCodes + lNumNext)
		        ReDim Preserve CodesBeg(2,lNumCodes + lNumNext)
		        For l = UBound(Codes,2) To 1 Step -1
		            If l > lNumNext Then
		                Codes(CODE,l) = Codes(CODE,l - lNumNext)
		                Codes(STATUS,l) = Codes(STATUS,l - lNumNext)
		                CodesBeg(CODE,l) = CodesBeg(CODE,l - lNumNext)
		                CodesBeg(STATUS,l) = CodesBeg(STATUS,l - lNumNext)
		            Else
		                Codes(CODE,l) = NextCodes(lNumNext - l + 1)
		                CodesBeg(CODE,l) = NextCodesBeg(lNumNext - l + 1)
		                Select Case Codes(CODE,l)
		                Case "</td></tr></table>", "</li>"
		                    Codes(STATUS,l) = "PG"
		                    CodesBeg(STATUS,l) = "PG"
		                Case Else
		                    Codes(STATUS,l) = "P"
		                    CodesBeg(STATUS,l) = "P"
		                End Select
		            End If
		        Next
		        ReDim NextCodes(0)
		        ReDim NextCodesBeg(0)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function Codes2Next ()
		    'move codes from "current" stack to pending ("next") stack
		    Dim lNumCodes
		    Dim l

		    If UBound(Codes,2) > 0 Then
		        lNumCodes = UBound(NextCodes)
		        ReDim Preserve NextCodes(lNumCodes + UBound(Codes,2))
		        ReDim Preserve NextCodesBeg(lNumCodes + UBound(Codes,2))
		        For l = 1 To UBound(Codes,2)
		            NextCodes(lNumCodes + l) = Codes(CODE,l)
		            NextCodesBeg(lNumCodes + l) = CodesBeg(CODE,l)
		        Next
		        ReDim Codes(2,0)
		        ReDim CodesBeg(2,0)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ParseFont ( strColor, strSize, strFace )
		    Dim strTmpFont

		    If strColor & strSize & strFace = "" Then
		        strTmpFont = ""
		    Else
		        strTmpFont = "<font"
		        If strFace <> "" Then
		           strTmpFont = strTmpFont & " face=""" & strFace & """"
		        End If
		        If strColor <> "" Then
		           strTmpFont = strTmpFont & " color=""" & strColor & """"
		        End If
		        If strSize <> "" And (strSize) <> iDefFontSize Then
		            strTmpFont = strTmpFont & " size=" & strSize
		        End If
		        strTmpFont = strTmpFont & ">"
		    End If
		    ParseFont = strTmpFont
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function PopCode ()
		    If UBound(Codes,2) > 0 Then
		        PopCode = Codes(CODE,UBound(Codes,2))
		        ReDim Preserve Codes(2,UBound(Codes,2) - 1)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ProcessAfterTextCodes ()
		    Dim strTmp
		    Dim l
		    Dim lLastKilled
		    Dim lRetVal

'check for/handle font change
		    If strFont <> GetLastFont Then
		        KillCode "</font>",""
		        
		        If Len( strFont ) > 0 Then
		            lRetVal = ReplaceInNextBeg( "</font>", strFont )
		            
		            If lRetVal = 0 Then
		                PushNext( "</font>" )
		                PushNextBeg( strFont )
		            End If
		        End If
		    Else
		        If Not InNext( "</li>" ) Then ReviveCode ( "</font>" )
		    End If

		    'now handle everything killed and move codes farther in to next
		    '    ie: \b B\i B \u B\i0 B \u0\b0 => <b>B<i>B<u>B</u>B</i><u>B</u></b>
		    strTmp = ""
		    
		    If UBound( Codes,2 ) > 0 Then
		        lLastKilled = 0
		        
		        For l = UBound( Codes, 2 ) To 1 Step -1
		            If Codes( STATUS, l ) = "K" Then
		                lLastKilled = l
		                Exit For
		            End If
		        Next
		        
		        If lLastKilled > 0 Then
		            For l = 1 To lLastKilled
		                strTmp = strTmp & Codes( CODE, l )
		                
		                If Codes( CODE, l ) = "</li>" Then strTmp = strTmp & strCR
		            Next
		            
		            For l = lLastKilled To 1 Step -1
		                If Codes( STATUS, l ) <> "D" And Codes( STATUS, l ) <> "K" Then
		                    If Not InNext( Codes( CODE, l) ) Then
		                        PushNext( Codes( CODE, l ) )
		                        PushNextBeg( CodesBeg( CODE, l ) )
		                    End If
		                    
		                    Codes( STATUS, l ) = "K"
		                    CodesBeg( STATUS, l ) = "K"
		                End If
		            Next
		        End If
		    End If
		    
		    ProcessAfterTextCodes = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetActiveCodes ()
		    Dim strTmp
		    Dim l

		    strTmp = ""
		    
		    If UBound( Codes, 2 ) > 0 Then
		        For l = 1 To UBound( Codes, 2 )
		            strTmp = strTmp & Codes( CODE, l )
		        Next
		    End If
		    
		    GetActiveCodes = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetLastFont ()
		    Dim strTmp
		    Dim l

		    strTmp = ""
		    If UBound(Codes,2) > 0 Then
		        For l = UBound(Codes,2) To 1 Step -1
		            If Codes(CODE,l) = "</font>" Then
		                strTmp = CodesBeg(CODE,l)
		                Exit For
		            End If
		        Next
		    End If
		    GetLastFont = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function SetPendingCodesActive ()
		    Dim strTmp
		    Dim l

		    strTmp = ""
		    If UBound(Codes,2) > 0 Then
		        For l = 1 To UBound(Codes,2)
		            If Codes(STATUS,l) = "P" Then
		                Codes(STATUS,l) = "A"
		                CodesBeg(STATUS,l) = "A"
		            ElseIf Codes(STATUS,l) = "PG" Then
		                Codes(STATUS,l) = "G"
		                CodesBeg(STATUS,l) = "G"
		            End If
		        Next
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function KillCode ( strCode, strExcept )   ' che: strExcept should be optional and would then be "" by default
		    'mark all codes of type strCode as killed
		    '    except where code or status = strExcept
		    '    if strCode = "*" then mark all killed
		    Dim strTmp
		    Dim l

		    strTmp = ""
		    
		    If UBound( Codes, 2 ) > 0 Then
		        If Left( strExcept, 1 ) = "<" Then    'strExcept is either a code or a status
		            For l = 1 To UBound( Codes, 2 )
		                If ( Codes( CODE, l ) = strCode Or strCode = "*" ) And Codes( CODE, l ) <> strExcept Then
		                    Codes( STATUS, l ) = "K"
		                    CodesBeg( STATUS, l ) = "K"
		                End If
		                
		                If strCode = "*" And Codes( CODE, l ) = strExcept Then Exit For
		            Next
		        Else
		            For l = 1 To UBound( Codes, 2 )
		                If ( Codes( CODE, l ) = strCode Or strCode = "*" ) And Codes( STATUS, l ) <> strExcept Then
		                    Codes( STATUS, l ) = "K"
		                    CodesBeg( STATUS, l ) = "K"
		                End If
		            Next
		        End If
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetAllCodesTill ( strTill )
		    'get all codes except strTill
		    Dim strTmp
		    Dim l

		    strTmp = ""
		    If UBound(Codes,2) > 0 Then
		        For l = UBound(Codes,2) To 1 Step -1
		            If Codes(CODE,l) = strTill Then
		                Exit For
		            Else
		                If Not InNextBeg(CodesBeg(CODE,l)) And Codes(STATUS,l) <> "D" Then
		                    strTmp = strTmp & Codes(CODE,l)
		                    Codes(STATUS,l) = "K"
		                    CodesBeg(STATUS,l) = "K"
		                End If
		            End If
		        Next
		    End If
		    GetAllCodesTill = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetAllCodesBeg ()
		    Dim strTmp
		    Dim l

		    strTmp = ""
		    If UBound(CodesBeg,2) > 0 Then
		        For l = UBound(CodesBeg,2) To 1 Step -1
		            If CodesBeg(STATUS,l) = "P" Then
		                strTmp = strTmp & CodesBeg(CODE,l)
		                CodesBeg(STATUS,l) = "A"
		                Codes(STATUS,l) = "A"
		            ElseIf CodesBeg(STATUS,l) = "PG" Then
		                strTmp = strTmp & CodesBeg(CODE,l)
		                CodesBeg(STATUS,l) = "G"
		                Codes(STATUS,l) = "G"
		            End If
		        Next
		    End If
		    GetAllCodesBeg = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetAllCodesBegTill ( strTill )
		    'get all codes except strTill - stop if strTill reached
		    '"<table"
		    Dim strTmp
		    Dim l

		    strTmp = ""
		    If UBound(CodesBeg,2) > 0 Then
		        For l = 1 To UBound(CodesBeg,2)
		            If Codes(CODE,l) = strTill Then
		                Exit For
		            Else
		                If CodesBeg(STATUS,l) = "P" Then
		                    strTmp = strTmp & CodesBeg(CODE,l)
		                    Codes(STATUS,l) = "A"
		                    CodesBeg(STATUS,l) = "A"
		                ElseIf CodesBeg(STATUS,l) = "PG" Then
		                    strTmp = strTmp & CodesBeg(CODE,l)
		                    Codes(STATUS,l) = "G"
		                    CodesBeg(STATUS,l) = "G"
		                End If
		            End If
		        Next
		    End If
		    GetAllCodesBegTill = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ShiftNext ()
		    'get 1st code off list and shorten list
		    Dim l

		    If UBound(NextCodes) > 0 Then
		        ShiftNext = NextCodes(1)
		        For l = 1 To UBound(NextCodes) - 1
		            NextCodes(l) = NextCodes(l + 1)
		        Next
		        ReDim Preserve NextCodes(UBound(NextCodes) - 1)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ShiftNextBeg ()
		    'get 1st code off list and shorten list
		    Dim l

		    If UBound(NextCodesBeg) > 0 Then
		        ShiftNextBeg = NextCodesBeg(1)
		        For l = 1 To UBound(NextCodesBeg) - 1
		            NextCodesBeg(l) = NextCodesBeg(l + 1)
		        Next
		        ReDim Preserve NextCodesBeg(UBound(NextCodesBeg) - 1)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ProcessWord ( strWord )
		    Dim strTmp
		    Dim strTmpbeg
		    Dim l
		    Dim gPopAll
		    Dim lRetVal

		    Dim strTableAlign              'current table alignment for setting up tablestring
		    Dim strTableWidth              'current table width for setting up tablestring

		    If lSkipWords > 0 Then
		        lSkipWords = lSkipWords - 1
		        Exit Function
		    End If
		    
		    If Left(strWord, 1) = "\" Or Left(strWord, 1) = "{" Or Left(strWord, 1) = "}" Then
		        strWord = Trim(strWord)
		        Select Case Left(strWord, 2)
		        Case "}"
		            If lBrLev = 0 Then
		                lRetVal = KillCode ( "*", "G" )
		                ClearNext ( "</li>" )
		                ClearFont
		            End If
		        Case "\'"    'special characters
		            strTmp = HTMLCode(Mid(strWord, 3))
		            If Left(strTmp, 6) = "<rtf>:" Then
		                strSecTmp = Mid(strTmp, 7) & " " & strSecTmp
		            Else
		                strSecTmp = strTmp & strSecTmp
		            End If
		        Case "\b"    'bold
		            If strWord = "\b" Then
		                If InCodes("</b>", True) Then
'		                    Codes2NextTill ("</b>")
		                Else
		                    PushNext ("</b>")
		                    PushNextBeg ("<b>")
		                End If
		            ElseIf strWord = "\bullet" Then
		                'If Not (Codes(CODE,UBound(Codes,2)) = "</li>" And Codes(STATUS,UBound(Codes,2)) = "A") Then
		                PushNext ("</li>")
		                PushNextBeg ("<li>")
		                'End If
		            ElseIf strWord = "\b0" Then    'bold off
		                If InCodes("</b>",False) Then
		                    Codes2NextTill ("</b>")
		                    KillCode "</b>",""
		                End If
		                If InNext("</b>") Then
		                    RemoveFromNext ("</b>")
		                End If
		            End If
		        Case "\c"
		            If strWord = "\cf0" Then    'color font off
		                strFontColor = ""
		                strFont = ParseFont(strFontColor, strFontSize, strFace)
		            ElseIf Left(strWord, 3) = "\cf" And IsNumeric(Mid(strWord, 4)) Then  'color font
		                'get color code
		                l = (Mid(strWord, 4))
		                If l <= UBound(strColorTable) And l > 0 Then
		                    strFontColor = "#" & strColorTable(l)
		                End If

		                'insert color
		                If strFontColor <> "#" Then
		                    strFont = ParseFont(strFontColor, strFontSize, strFace)
		                    If InNext("</font>") Then
		                        ReplaceInNextBeg "</font>", strFont
		                    ElseIf InCodes("</font>",False) Then
		                        PushNext ("</font>")
		                        PushNextBeg (strFont)
		                        Codes2NextTill "</font>"
		                        KillCode "</font>",""
		                    Else
		                        PushNext ("</font>")
		                        PushNextBeg (strFont)
		                    End If
		                End If
		            End If
' che: ignore font and fontsize for now
       Case "\f"
           If Left(strWord, 3) = "\fs" And IsNumeric(Mid(strWord, 4)) Then  'font size
               l = (Mid(strWord, 4))
               lFontSize = Int((l / 7) - 0)    'calc to convert RTF to HTML sizes
               If lFontSize > 8 Then lFontSize = 8
               If lFontSize < 1 Then lFontSize = 1
               strFontSize = Trim(lFontSize)
               If (strFontSize) = iDefFontSize Then strFontSize = ""
               'insert size
               strFont = ParseFont(strFontColor, strFontSize, strFace)
           End If
' che       Case "\f"
' che           If Left(strWord, 3) = "\fs" And IsNumeric(Mid(strWord, 4)) Then  'font size
' che               l = (Mid(strWord, 4))
' che               lFontSize = Int((l / 7) - 0)    'calc to convert RTF to HTML sizes
' che               If lFontSize > 8 Then lFontSize = 8
' che               If lFontSize < 1 Then lFontSize = 1
' che               strFontSize = Trim(lFontSize)
' che               If (strFontSize) = iDefFontSize Then strFontSize = ""
' che               'insert size
' che               strFont = ParseFont(strFontColor, strFontSize, strFace)
' che           ElseIf Left(strWord, 2) = "\f" And IsNumeric(Mid(strWord, 3)) And gUseFontFace Then  'font type
' che               l = (Mid(strWord, 3))
' che               If l <= UBound(strFontTable) And l > 0 Then
' che                   strFace = strFontTable(l)
' che               End If
' che               strFont = ParseFont(strFontColor, strFontSize, strFace)
' che           End If
		        Case "\i"
		            If strWord = "\i" Then 'italics
		                If InCodes("</i>", True) Then
'		                    Codes2NextTill ("</i>")
		                Else
		                    PushNext ("</i>")
		                    PushNextBeg ("<i>")
		                End If
		            ElseIf strWord = "\i0" Then 'italics off
		                If InCodes("</i>",False) Then
		                    Codes2NextTill ("</i>")
		                    KillCode "</i>",""
		                End If
		                If InNext("</i>") Then
		                    RemoveFromNext ("</i>")
		                End If
		            End If
		        Case "\l"
		            'If strWord = "\listname" Then
		            '    lSkipWords = 1
		            'End If
		        Case "\n"
		            If strWord = "\nosupersub" Then    'superscript/subscript off
		                If InCodes("</sub>", True) Then
		                    Codes2NextTill ("</sub>")
		                    KillCode "</sub>",""
		                End If
		                If InNext("</sub>") Then
		                    RemoveFromNext ("</sub>")
		                End If
		                If InCodes("</sup>", True) Then
		                    Codes2NextTill ("</sup>")
		                    KillCode "</sup>",""
		                End If
		                If InNext("</sup>") Then
		                    RemoveFromNext ("</sup>")
		                End If
		            End If
		        Case "\p"
		            If strWord = "\par" Then
		                If Not ( InCodes( "</ul>", False ) Or InCodes( "</li>", False ) ) Then
' che: replaced <br> by <br/> for compatibility with xml
		                    strBeforeText2 = strBeforeText2 & strEOL & "<br/>" & strCR
		                Else
 		                    lRetVal = KillCode ( "</li>", "" )
 		                    RemoveFromNext ( "</li>" )
		                End If
		                
		                gBOL = True
		                gPar = True
		                'If InCodes("</ul>",False) Then
		                '    PushNext ("</li>")
		                '    PushNextBeg ("<li>")
		                'End If
		            ElseIf strWord = "\pard" Then
		                For l = 1 To UBound(CodesBeg,2)
		                    If Codes(STATUS,l) = "G" Or Codes(STATUS,l) = "PG" Then
		                        Codes(STATUS,l) = "K"
		                        CodesBeg(STATUS,l) = "K"
		                    End If
		                Next
		                If Not gIgnorePard Then
		                    If InCodes("</li>",False) Then
 		                        lRetVal = KillCode ("</li>","")
		                        RemoveFromNext ("</li>")
		                    End If
		                End If
		                gPar = True
		            ElseIf strWord = "\plain" Then
		                lRetVal = KillCode ("*", "G")
		                ClearFont
		            ElseIf strWord = "\pnlvlblt" Then 'bulleted list
 		                If Not InNext("</li>") Then
 		                    PushNext ("</li>")
 		                    PushNextBeg ("<li>")
 		                End If
		                'PushNext ("</ul>")
		                'PushNextBeg ("<ul>")
		            ElseIf strWord = "\pntxta" Then 'numbered list?
		                lSkipWords = 1
		            ElseIf strWord = "\pntxtb" Then 'numbered list?
		                lSkipWords = 1
		            ElseIf strWord = "\pntext" Then 'bullet
 		                If Not InNext( "</li>" ) Then
 		                    PushNext ( "</li>" )
 		                    PushNextBeg ( "<li>" )
' che: replaced </table> by </li>
                        Codes2NextTill ( "</li>" )
 		                    KillCode "*", ""
 		                End If
		            End If
		        Case "\q"
		            If strWord = "\qc" Then    'centered
		                strTableAlign = "center"
		                strTableWidth = "100%"
		                If InNext("</td></tr></table>") Then
		                    '?
		                Else
		                    strTable = "<table width=" & strTableWidth & "><tr><td align=""" & strTableAlign & """>"
		                End If
		                If InNext("</td></tr></table>") Then
		                    ReplaceInNextBeg "</td></tr></table>", strTable
		                ElseIf InCodes("</td></tr></table>",False) Then
		                    PushNext ("</td></tr></table>")
		                    PushNextBeg (strTable)
		                    Codes2NextTill "</td></tr></table>"
		                Else
		                    PushNext ("</td></tr></table>")
		                    PushNextBeg (strTable)
		                End If
		            ElseIf strWord = "\qr" Then    'right justified
		                strTableAlign = "right"
		                strTableWidth = "100%"
		                If InNext("</td></tr></table>") Then
		                    '?
		                Else
		                    strTable = "<table width=" & strTableWidth & "><tr><td align=""" & strTableAlign & """>"
		                End If
		                If InNext("</td></tr></table>") Then
		                    ReplaceInNextBeg "</td></tr></table>", strTable
		                ElseIf InCodes("</td></tr></table>",False) Then
		                    PushNext ("</td></tr></table>")
		                    PushNextBeg (strTable)
		                    Codes2NextTill "</td></tr></table>"
		                Else
		                    PushNext ("</td></tr></table>")
		                    PushNextBeg (strTable)
		                End If
		            End If
		        Case "\s"
		            If strWord = "\strike" Then    'strike text
		                If Codes(CODE,UBound(Codes,2)) <> "</s>" Or (Codes(CODE,UBound(Codes,2)) = "</s>" And CodesBeg(CODE,UBound(Codes,2)) = "") Then
		                    PushNext ("</s>")
		                    PushNextBeg ("<s>")
		                End If
		            ElseIf strWord = "\strike0" Then    'strike off
		                If InCodes("</s>",False) Then
		                    Codes2NextTill ("</s>")
		                    KillCode "</s>",""
		                End If
		                If InNext("</s>") Then
		                    RemoveFromNext ("</s>")
		                End If
		            ElseIf strWord = "\super" Then    'superscript
		                If Codes(CODE,UBound(Codes,2)) <> "</sup>" Or (Codes(CODE,UBound(Codes,2)) = "</sup>" And CodesBeg(CODE,UBound(Codes,2)) = "") Then
		                    PushNext ("</sup>")
		                    PushNextBeg ("<sup>")
		                End If
		            ElseIf strWord = "\sub" Then    'subscript
		                If Codes(CODE,UBound(Codes,2)) <> "</sub>" Or (Codes(CODE,UBound(Codes,2)) = "</sub>" And CodesBeg(CODE,UBound(Codes,2)) = "") Then
		                    PushNext ("</sub>")
		                    PushNextBeg ("<sub>")
		                End If
		            End If

		            'If strWord = "\snext0" Then    'style
		            '    lSkipWords = 1
		            'End If
		        Case "\t"
		            If strWord = "\tab" Then    'tab
		                strSecTmp = vbTab & strSecTmp
		            End If
		        Case "\u"
		            If strWord = "\ul" Then    'underline
		                If InCodes("</u>", True) Then
'		                    Codes2NextTill ("</u>")
		                Else
		                    PushNext ("</u>")
		                    PushNextBeg ("<u>")
		                End If
		            ElseIf strWord = "\ulnone" Then    'stop underline
		                If InCodes("</u>",False) Then
		                    Codes2NextTill ("</u>")
		                    KillCode "</u>",""
		                End If
		                If InNext("</u>") Then
		                    RemoveFromNext ("</u>")
		                End If
		            End If
		        End Select
		    Else
		        If Len(strWord) > 0 Then
		            If Trim(strWord) = "" Then
		                If gBOL Then strWord = rtf2html_replace(strWord, " ", "&nbsp;")
		                strCurPhrase = strCurPhrase & strBeforeText3 & strWord
		            Else
		                'regular text
		                If gPar Then
		                    strBeforeText = strBeforeText & ProcessAfterTextCodes
		                    Next2Codes
		                    strBeforeText3 = GetAllCodesBeg
		                    gPar = False
		                Else
		                    strBeforeText = strBeforeText & ProcessAfterTextCodes
		                    Next2Codes
		                    strBeforeText3 = GetAllCodesBegTill("</td></tr></table>")
		                End If
		                RemoveBlanks

		                strCurPhrase = strCurPhrase & strBeforeText
		                strBeforeText = ""
		                strCurPhrase = strCurPhrase & strBeforeText2
		                strBeforeText2 = ""
		                strCurPhrase = strCurPhrase & strBeforeText3 & strWord
		                strBeforeText3 = ""
		                gBOL = False
		            End If
		        End If
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function PushNext ( strCode )
		    If Len( strCode ) > 0 Then
		        ReDim Preserve NextCodes( UBound( NextCodes ) + 1 )
		        NextCodes( UBound( NextCodes ) ) = strCode
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function UnShiftNext ( strCode )
		    'stick strCode on front of list and move everything over to make room
		    Dim l

		    If Len( strCode ) > 0 Then
		        ReDim Preserve NextCodes( UBound( NextCodes ) + 1 )
		        
		        If UBound( NextCodes ) > 1 Then
		            For l = UBound( NextCodes ) To 1 Step -1
		                NextCodes( l ) = NextCodes( l - 1 )
		            Next
		        End If
		        
		        NextCodes( 1 ) = strCode
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function UnShiftNextBeg ( strCode )
		    Dim l

		    If Len( strCode ) > 0 Then
		        ReDim Preserve NextCodesBeg( UBound( NextCodesBeg ) + 1 )
		        
		        If UBound( NextCodesBeg ) > 1 Then
		            For l = UBound( NextCodesBeg ) To 1 Step -1
		                NextCodesBeg( l ) = NextCodesBeg( l - 1 )
		            Next
		        End If
		        NextCodesBeg( 1 ) = strCode
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function PushNextBeg ( strCode )
		    ReDim Preserve NextCodesBeg( UBound( NextCodesBeg ) + 1 )
		    NextCodesBeg( UBound( NextCodesBeg ) ) = strCode
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function RemoveBlanks ()
		    Dim l
		    Dim lOffSet

		    l = 1
		    lOffSet = 0
		    While l <= UBound(CodesBeg,2) And l + lOffSet <= UBound(CodesBeg,2)
		        If CodesBeg(STATUS,l) = "K" Or CodesBeg(STATUS,l) = "" Then     'And Not (Codes(CODE,l) = "</font>" And Len(strFont) > 0) Then
		            lOffSet = lOffSet + 1
		        Else
		            l = l + 1
		        End If
		        If l + lOffSet <= UBound(CodesBeg,2) Then
		            Codes(CODE,l) = Codes(CODE,l + lOffSet)
		            Codes(STATUS,l) = Codes(STATUS,l + lOffSet)
		            CodesBeg(CODE,l) = CodesBeg(CODE,l + lOffSet)
		            CodesBeg(STATUS,l) = CodesBeg(STATUS,l + lOffSet)
		        End If
		    Wend
		    If lOffSet > 0 Then
		        ReDim Preserve Codes(2,UBound(Codes,2) - lOffSet)
		        ReDim Preserve CodesBeg(2,UBound(CodesBeg,2) - lOffSet)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function RemoveFromNext ( strRem )
		    Dim l
		    Dim m
		    Dim finally

		    finally = False
		    If UBound(NextCodes) < 1 Then finally = True
		    If Not finally Then
			    l = 1
			    While l < UBound(NextCodes)
			        If NextCodes(l) = strRem Then
			            For m = l To UBound(NextCodes) - 1
			                NextCodes(m) = NextCodes(m + 1)
			                NextCodesBeg(m) = NextCodesBeg(m + 1)
			            Next
			            l = m
			        Else
			            l = l + 1
			        End If
			    Wend
			    ReDim Preserve NextCodes(UBound(NextCodes) - 1)
			    ReDim Preserve NextCodesBeg(UBound(NextCodesBeg) - 1)
			  End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function rtf2html_replace( ByVal strIn, ByVal strRepl, ByVal strWith )
		    'replace all instances of strRepl in strIn with strWith
		    Dim i

		    If ((Len(strRepl) = 0) Or (Len(strIn) = 0)) Then
		        rtf2html_replace = strIn
		        Exit Function
		    End If
		    i = InStr(strIn, strRepl)
		    While i <> 0
		        strIn = Left(strIn, i - 1) & strWith & Mid(strIn, i + Len(strRepl))
		        i = InStr(i + Len(strWith), strIn, strRepl)
		    Wend
		    rtf2html_replace = strIn
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ReviveCode ( strCode )
		    Dim l

		    For l = 1 To UBound(Codes,2)
		        If Codes(CODE,l) = strCode Then
		            Codes(STATUS,l) = "A"
		            CodesBeg(STATUS,l) = "A"
		        End If
		    Next
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ReplaceInNextBeg ( strCode, strWith )
		    Dim l
		    Dim lCount            'number of codes replaced

		    lCount = 0
		    For l = 1 To UBound(NextCodes)
		        If NextCodes(l) = strCode Then
		            NextCodesBeg(l) = strWith
		            lCount = lCount + 1
		        End If
		    Next
		    ReplaceInNextBeg = lCount
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function ReplaceInCodesBeg ( strCode, strWith )
		    Dim l

		    l = 1
		    While l <= UBound(Codes,2) And Codes(CODE,l) <> strCode
		        l = l + 1
		    Wend
		    If Codes(CODE,l) = strCode Then
		        If CodesBeg(CODE,l) <> strWith Then
		            CodesBeg(CODE,l) = strWith
		            Codes(STATUS,l) = "P"
		            CodesBeg(STATUS,l) = "P"
		        Else
		            Codes(STATUS,l) = "P"
		            CodesBeg(STATUS,l) = "P"
		        End If
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function IsDig ( strChar )
		    If Len(strChar) = 0 Then
		        IsDig = False
		    Else
		        IsDig = InStr("1234567890", strChar)
		    End If
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function GetCodes ( strWordTmp )
		    Dim strTmp
		    Dim l

		    strTmp = "CurWord: "
		    If Len(strWordTmp) > 20 Then
		        strTmp = strTmp & Left(strWordTmp, 20) & "..."
		    Else
		        strTmp = strTmp & strWordTmp
		    End If
		    strTmp = strTmp & vbCrLf & vbCrLf & "BegCodes: "
		    For l = 1 To UBound(CodesBeg,2)
		        strTmp = strTmp & CodesBeg(CODE,l) & " (" & CodesBeg(STATUS,l) & "), "
		    Next
		    strTmp = strTmp & vbCrLf & "Codes: "
		    For l = 1 To UBound(Codes,2)
		        strTmp = strTmp & Codes(CODE,l) & " (" & Codes(STATUS,l) & "), "
		    Next
		    strTmp = strTmp & vbCrLf & vbCrLf & "NextBegCodes: "
		    For l = 1 To UBound(NextCodesBeg)
		        strTmp = strTmp & NextCodesBeg(l) & ", "
		    Next
		    strTmp = strTmp & vbCrLf & "NextCodes: "
		    For l = 1 To UBound(NextCodes)
		        strTmp = strTmp & NextCodes(l) & ", "
		    Next
		    strTmp = strTmp & vbCrLf & vbCrLf & "Font String: " & strFont
		    strTmp = strTmp & vbCrLf & vbCrLf & "Before Text: " & strBeforeText2
		    GetCodes = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function TrimAll( ByVal strTmp )
		    Dim l

		    strTmp = Trim(strTmp)
		    l = Len(strTmp) + 1
		    While l <> Len(strTmp)
		        l = Len(strTmp)
		        If Right(strTmp, 1) = vbCrLf Then strTmp = Left(strTmp, Len(strTmp) - 1)
		        If Left(strTmp, 1) = vbCrLf Then strTmp = Right(strTmp, Len(strTmp) - 1)
		        If Right(strTmp, 1) = vbCr Then strTmp = Left(strTmp, Len(strTmp) - 1)
		        If Left(strTmp, 1) = vbCr Then strTmp = Right(strTmp, Len(strTmp) - 1)
		        If Right(strTmp, 1) = vbLf Then strTmp = Left(strTmp, Len(strTmp) - 1)
		        If Left(strTmp, 1) = vbLf Then strTmp = Right(strTmp, Len(strTmp) - 1)
		    Wend
		    TrimAll = strTmp
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function HTMLCode ( strRTFCode )
		    'given rtf code return html code
		    Select Case strRTFCode
		    Case "00"
		        HTMLCode = "&nbsp;"
		    Case "a9"
		        HTMLCode = "&copy;"
		    Case "b4"
		        HTMLCode = "&acute;"
		    Case "ab"
		        HTMLCode = "&laquo;"
		    Case "bb"
		        HTMLCode = "&raquo;"
		    Case "a1"
		        HTMLCode = "&iexcl;"
		    Case "bf"
		        HTMLCode = "&iquest;"
		    Case "c0"
		        HTMLCode = "&Agrave;"
		    Case "e0"
		        HTMLCode = "&agrave;"
		    Case "c1"
		        HTMLCode = "&Aacute;"
		    Case "e1"
		        HTMLCode = "&aacute;"    'á
		    Case "c2"
		        HTMLCode = "&Acirc;"
		    Case "e2"
		        HTMLCode = "&acirc;"
		    Case "c3"
		        HTMLCode = "&Atilde;"
		    Case "e3"
		        HTMLCode = "&atilde;"
		    Case "c4"
		        HTMLCode = "Ä"
' che: splitted / replaced
' che   Case "e4", "99"
' che       HTMLCode = "<rtf>:\super TM\nosupersub"
' che - Begin
		    Case "e4"
		        HTMLCode = "ä"
		    Case "99"
		        HTMLCode = "<rtf>:\super TM\nosupersub"
' che - End
		    Case "c5"
		        HTMLCode = "&Aring;"
		    Case "e5"
		        HTMLCode = "&aring;"
		    Case "c6"
		        HTMLCode = "&AElig;"
		    Case "e6"
		        HTMLCode = "&aelig;"
		    Case "c7"
		        HTMLCode = "&Ccedil;"
		    Case "e7"
		        HTMLCode = "&ccedil;"
		    Case "d0"
		        HTMLCode = "&ETH;"
		    Case "f0"
		        HTMLCode = "&eth;"
		    Case "c8"
		        HTMLCode = "&Egrave;"
		    Case "e8"
		        HTMLCode = "&egrave;"
		    Case "c9"
		        HTMLCode = "&Eacute;"
		    Case "e9"
		        HTMLCode = "&eacute;"
		    Case "ca"
		        HTMLCode = "&Ecirc;"
		    Case "ea"
		        HTMLCode = "&ecirc;"
		    Case "cb"
		        HTMLCode = "&Euml;"
		    Case "eb"
		        HTMLCode = "&euml;"
		    Case "cc"
		        HTMLCode = "&Igrave;"
		    Case "ec"
		        HTMLCode = "&igrave;"
		    Case "cd"
		        HTMLCode = "&Iacute;"
		    Case "ed"
		        HTMLCode = "&iacute;"    'í
		    Case "ce"
		        HTMLCode = "&Icirc;"
		    Case "ee"
		        HTMLCode = "&icirc;"
		    Case "cf"
		        HTMLCode = "&Iuml;"
		    Case "ef"
		        HTMLCode = "&iuml;"
		    Case "d1"
		        HTMLCode = "&Ntilde;"
		    Case "f1"
		        HTMLCode = "&ntilde;"
		    Case "d2"
		        HTMLCode = "&Ograve;"
		    Case "f2"
		        HTMLCode = "&ograve;"
		    Case "d3"
		        HTMLCode = "&Oacute;"
		    Case "f3"
		        HTMLCode = "&oacute;"
		    Case "d4"
		        HTMLCode = "&Ocirc;"
		    Case "f4"
		        HTMLCode = "&ocirc;"
		    Case "d5"
		        HTMLCode = "&Otilde;"
		    Case "f5"
		        HTMLCode = "&otilde;"
		    Case "d6"
		        HTMLCode = "Ö"
		    Case "f6"
		        HTMLCode = "ö"
		    Case "d8"
		        HTMLCode = "&Oslash;"
		    Case "f8"
		        HTMLCode = "&oslash;"
		    Case "d9"
		        HTMLCode = "&Ugrave;"
		    Case "f9"
		        HTMLCode = "&ugrave;"
		    Case "da"
		        HTMLCode = "&Uacute;"
		    Case "fa"
		        HTMLCode = "&uacute;"
		    Case "db"
		        HTMLCode = "&Ucirc;"
		    Case "fb"
		        HTMLCode = "&ucirc;"
		    Case "dc"
		        HTMLCode = "Ü"
		    Case "fc"
		        HTMLCode = "ü"
		    Case "dd"
		        HTMLCode = "&Yacute;"
		    Case "fd"
		        HTMLCode = "&yacute;"
		    Case "ff"
		        HTMLCode = "&yuml;"
		    Case "de"
		        HTMLCode = "&THORN;"
		    Case "fe"
		        HTMLCode = "&thorn;"
		    Case "df"
		        HTMLCode = "ß"
		    Case "a7"
		        HTMLCode = "&sect;"
		    Case "b6"
		        HTMLCode = "&para;"
		    Case "b5"
		        HTMLCode = "&micro;"
		    Case "a6"
		        HTMLCode = "&brvbar;"
		    Case "b1"
		        HTMLCode = "&plusmn;"
		    Case "b7"
		        HTMLCode = "&middot;"
		    Case "a8"
		        HTMLCode = "&uml;"
		    Case "b8"
		        HTMLCode = "&cedil;"
		    Case "aa"
		        HTMLCode = "&ordf;"
		    Case "ba"
		        HTMLCode = "&ordm;"
		    Case "ac"
		        HTMLCode = "&not;"
		    Case "ad"
		        HTMLCode = "&shy;"
		    Case "af"
		        HTMLCode = "&macr;"
		    Case "b0"
		        HTMLCode = "&deg;"
		    Case "b9"
		        HTMLCode = "&sup1;"
		    Case "b2"
		        HTMLCode = "&sup2;"
		    Case "b3"
		        HTMLCode = "&sup3;"
		    Case "bc"
		        HTMLCode = "&frac14;"
		    Case "bd"
		        HTMLCode = "&frac12;"
		    Case "be"
		        HTMLCode = "&frac34;"
		    Case "d7"
		        HTMLCode = "&times;"
		    Case "f7"
		        HTMLCode = "&divide;"
		    Case "a2"
		        HTMLCode = "&cent;"
		    Case "a3"
		        HTMLCode = "&pound;"
		    Case "a4"
		        HTMLCode = "&curren;"
		    Case "a5"
		        HTMLCode = "&yen;"
		    Case "85"
		        HTMLCode = "..."
		    Case "9e"
		        HTMLCode = "_"    '_
		    Case "9a"
		        HTMLCode = "_"    '_
		    End Select
		End Function
		' --------------------------------------------------------------------



		' --------------------------------------------------------------------
		Function TrimifCmd( ByVal strTmp )
		    Dim l

		    l = 1
		    While Mid(strTmp, l, 1) = " "
		        l = l + 1
		    Wend
		    If Mid(strTmp, l, 1) = "\" Or Mid(strTmp, l, 1) = "{" Then
		        strTmp = Trim(strTmp)
		    Else
		        If Left(strTmp, 1) = " " Then strTmp = Mid(strTmp, 2)
		        strTmp = RTrim(strTmp)
		    End If
		    TrimifCmd = strTmp
		End Function
		' --------------------------------------------------------------------



		]]>
	</msxsl:script>
	<!-- #################################################################### -->



</xsl:stylesheet>