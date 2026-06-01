'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Use this file to transform a XML document with corresponding
' XSLT stylesheet. This script is able to pass to XSLT any number
' of parameters.
'
' In order to use invoke the following command from the command line:
' 
' 	transform.vbs [parameter1_name=parameter1_value] [...]
'
' Make sure to change constants pointing to the files to process.
' Note that parameters parameter1_name, parameter2_name, etc. must
' be declared in xslFile with <xsl:param> tag.
'
' Copyright (c) 2001 startext GmbH
' Created by Ilya Khandamirov (ikh@startext.de)
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Constants. Change if needed.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Const xmlFile = ".\..\..\nachweis_daten\3_0_Produktion\Leipzig_Universitaetsbibliothek\02_Leipzig_UB_Paket1-15_a_Beschr_EXT_200Beschrr.xml"
	Const xslFile = ".\Hida4.xsl"
	Const outputFile = ".\HiDA_Export_sample_ohneRTF.xml"


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Create needed objects, initialize properties, load documents
' 
' IMPORTANT. Do not change the code below this line unless you know
' exactly what you are doing.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Set objXML = CreateObject("Msxml2.DOMDocument")
	Set objXSL = CreateObject("MSXML2.FreeThreadedDOMDocument")

	objXML.async = false
	objXSL.async = false

	objXML.validateOnParse = false
	objXSL.validateOnParse = false
	
	objXML.resolveExternals = false
	objXSL.resolveExternals = false

	objXML.preserveWhiteSpace = True
	objXSL.preserveWhiteSpace = True

	objXML.load(xmlFile)
	if objXML.parseError.errorCode <> 0 then ErrorMessageParse(objXML.parseError)

	objXSL.load(xslFile)
  objXSL.setProperty "SelectionLanguage", "XPath"
  objXSL.setProperty "SelectionNamespaces", "xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"""
	if objXSL.parseError.errorCode <> 0 then  ErrorMessageParse(objXSL.parseError)

	' Create IStream object from ADODB.Stream to hold the output.
	' Required to preserve the encoding.
	' At the moment of writing only 3 objects supported the IStream intertface:
	' ADODB.Stream, IIS5 Response object, and an MSXML DomDocument.
	Set resultStr = CreateObject("ADODB.Stream")
	Set XMLNode = objXSL.selectSingleNode("//xsl:output/@encoding")
	If XMLNode Is Nothing Then
		resultStr.Charset = "UTF-16"
	Else
		resultStr.Charset = XMLNode.nodeValue
	End If
	resultStr.Open

	Set template = CreateObject("MSXML2.XSLTemplate")
	template.stylesheet = objXSL.documentElement
	Set processor = template.createProcessor()
	processor.input = objXML
	processor.output = resultStr

	
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Retrieve command line parameters and pass 'em to XSLT processor.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Set objArgs = WScript.Arguments
	For i = 0 to objArgs.Count - 1
		eqvSignPos = InStr(1, objArgs(i), "=")
		If eqvSignPos > 0 Then
			param_name = Mid(objArgs(i), 1, eqvSignPos - 1)
			param_value = Mid(objArgs(i), eqvSignPos + 1, Len(objArgs(i)) - 1)
			If Trim(param_name) <> "" And Trim(param_value) <> "" Then _
				processor.addParameter param_name, param_value
		End If
	Next


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Perform actual transformation and save the result.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	processor.transform()

	'adSaveCreateOverWrite=2
	resultStr.SaveToFile outputFile, 2


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' At the end clean up and display status message.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Set processor = Nothing
	Set template = Nothing
	Set resultStr = Nothing
	Set XMLNode = Nothing
	Set objArgs = Nothing
	Set objXML = Nothing
	Set objXSL = Nothing


	If Err.Number <> 0 Then
		ErrorMessage(Err.description)
	Else
		ErrorMessage("Transformation completed.")
	End If


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' End of script. Subprocedures see below.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Sub-procedures.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub ErrorMessage(msg)
	MsgBox(msg)
	WScript.Quit 1
End Sub

Sub ErrorMessageParse(objErr)
	strError = "Invalid XML file!" & vbCrlf _
		& "File: " & objErr.url & vbCrlf _
		& "Line: " & objErr.line & vbCrlf _
		& "Character: " & objErr.linepos & vbCrlf _
		& "File position: " & objErr.filepos & vbCrlf _
		& "Source text: " & objErr.srcText & vbCrlf _
		& "Error code: " & objErr.errorCode & vbCrlf _
		& "Description: " & objErr.reason
	MsgBox strError
	WScript.Quit 1
End Sub
