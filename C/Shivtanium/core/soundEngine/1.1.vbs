'-------------------------------------------------------------------------------
' USAGE
'     play_snippet.vbs <file> [start_time] [duration]
'
' MANDATORY ARGUMENTS
'     file       - String. The name of the file to play. Full path is
'                  recommended, but not required.
'
' OPTIONAL ARGUMENTS
'     start_time - Double. The number of milliseconds that should be skipped
'                  from the beginning of the script. Default is 0.
'     duration   - Integer. The number of milliseconds that the audio should
'                  be played. Not specifying a value plays the entire file.
'
' DESCRIPTION
'     Plays a snippet of an audio file.
'     Based on the same few snippets that can be found everywhere online.
'
' AUTHOR
'     sintrode
'
' VERSION    DATE          AUTHOR      DESCRIPTION
' -------    ----------    --------    -----------------------------------------
'     1.1    2018-08-29    sintrode    - Added mandatory and optional arguments
'                                      - Reorganized code to use subroutines
'     1.0    2018-08-28    sintrode    - Initial version
'-------------------------------------------------------------------------------
Option Explicit

'-------------------------------------------------------------------------------
' Displays the script usage
'
' Arguments: None
' Returns:   None
'-------------------------------------------------------------------------------
Sub Usage
	With WScript
		.Echo "Usage: play_snippet.vbs <file> [start_time] [duration]"
		.Echo "file       - The name of the file to play"
		.Echo "start_time - The number of milliseconds that should be" & _
		                  " skipped at the beginning"
		.Echo "duration   - The number of milliseconds that the audio" & _
		                  " should play for"
		
		' Wait for two seconds so that the people who originally ran the script
		' via wscript have a chance to read the usage message
		.Sleep 2000
		.Quit
	End With
End Sub

'-------------------------------------------------------------------------------
' Forces the use of cscript so that the usage message doesn't get displayed as
' a series of messageboxes
'
' Source:    https://stackoverflow.com/a/5219524/4158862
' Arguments: None
' Returns:   None
'-------------------------------------------------------------------------------
Sub ForceCscript
	Dim argument, arg_string
	
	If Not LCase(Right(WScript.FullName, 11)) = "cscript.exe" Then
		For Each argument in WScript.Arguments
			If InStr(argument, " ") Then argument = """" & argument & """"
			arg_string = arg_string & " " & argument
		Next
		
		' Call the script again, but use cscript //nologo
		CreateObject("WScript.Shell").Run "cscript //nologo """ & _
		WScript.ScriptFullName & """ " & arg_string
		
		WScript.Quit
	End If
End Sub

'-------------------------------------------------------------------------------
' Gets the duration of the file and returns it in milliseconds
'
' Source:    https://stackoverflow.com/a/19812711/4158862
' Arguments: file_name - The name or full path to the file
' Returns:   The duration of the audio in milliseconds
'-------------------------------------------------------------------------------
Function GetAudioDuration(filename)
	Dim audio_length
	
	With CreateObject("WMPlayer.OCX")
        .settings.mute = True
        .url = filename
		
		' I have no idea why this is here but it doesn't work without it
        Do While Not .playState = 3
            WScript.Sleep 50
        Loop
		
        audio_length = Round(.currentMedia.duration)
        .Close 
    End With
	
	' Return milliseconds
	GetAudioDuration = audio_length * 1000
End Function

'-------------------------------------------------------------------------------
' Plays a section of a specified audio file
'
' Arguments: file_name - The name or full path to the file
'            skip_time - The number of seconds to skip
'            play_time - The number of miliseconds to play the file
' Returns:   None
'-------------------------------------------------------------------------------
Sub PlayAudio(file_name, skip_time, play_time)
	Dim wmp_object : Set wmp_object = CreateObject("WMPlayer.OCX")
	
	With wmp_object
		.URL = file_name
		
		With .Controls
			' Play the audio
			.CurrentPosition = skip_time
			.Play
			
			' Stop the audio after ____ milliseconds
			WScript.Sleep play_time
			.Stop
		End With
		
		' Release the audio file
		.Close
	End With
End Sub

'-------------------------------------------------------------------------------
'                                 MAIN  SECTION
'-------------------------------------------------------------------------------
ForceCscript

Dim filename, start_time, duration

' Process arguments and set any non-default values
With WScript
	If .Arguments.Count = 0 Then Usage
	filename = .Arguments(0)
	start_time = 0
	duration = GetAudioDuration(filename)
	If .Arguments.Count > 1 Then start_time = .Arguments(1) / 1000
	If .Arguments.Count > 2 Then duration = .Arguments(2)
End With

Call PlayAudio(filename, start_time, duration)
