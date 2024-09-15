'-------------------------------------------------------------------------------
' USAGE
'     play_snippet.vbs <file> [start_time] [duration] [volume]
'
' MANDATORY ARGUMENTS
'     file       - String. The name of the file to play. Full path is
'                  recommended, but not required.
'
' OPTIONAL ARGUMENTS
'	start_time	- Double. The number of milliseconds that should be skipped
'			  from the beginning of the script. Default is 0.
'	duration	- Integer. The number of milliseconds that the audio should
'			  be played. Not specifying a value plays the entire file.
'
'	volume		- Integer from 0 to 100 to set the volume.
'
' FUNCTIONS
'
' PAUSE/RESUME		- Create a file named "pause.f" in .vbs folder to pause/resume.
'
'
' CHANGE VOLUME		- Create a file named "volume.f" what contains an integrer from 0-100
'			  to change the volume while playing.
'
' DESCRIPTION
'     Plays a snippet of an audio file.
'     Based on the same few snippets that can be found everywhere online.
'
' AUTHOR
'     sintrode, modify by RazorArt
'
'     VERSION      DATE          AUTHOR                       DESCRIPTION
'      -----   ------------    ----------      -----------------------------------------
'	1.2	2024-07-24	RazorArt	- Added volume, pause and resume.
'
'	1.1	2018-08-29	sintrode	- Added mandatory and optional arguments
'						- Reorganized code to use subroutines
'	1.0	2018-08-28	sintrode	- Initial version
'---------------------------------------------------------------------------------------
Option Explicit

'-------------------------------------------------------------------------------
' Displays the script usage
'
' Arguments: None
' Returns:   None
'-------------------------------------------------------------------------------
Sub Usage
	With WScript
		.Echo "Usage: play_snippet.vbs <file> [start_time] [duration] [volume]"
		.Echo "file       - The name of the file to play"
		.Echo "start_time - The number of milliseconds that should be" & _
		                  " skipped at the beginning"
		.Echo "duration   - The number of milliseconds that the audio" & _
		                  " should play for"
		.Echo "volume     - The number of start volume 0-100"
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
' Source:    'https://stackoverflow.com/a/19812711/4158862
' Arguments: file_name - The name or full path to the file
' Returns:   The duration of the audio in milliseconds
'-------------------------------------------------------------------------------
Function GetAudioDuration(filename)
	Dim audio_length
	
	With CreateObject("WMPlayer.OCX")
        	.settings.mute = True
        	.url = filename
		
		' This forces the script to wait til the music file it's loaded.
		' Translation: Do While file isn't playing: wait 50ms then repeat
        	Do While Not .playState = 3
          		  WScript.Sleep 50
       		Loop
		
        audio_length = Round(.currentMedia.duration)
        .Close 
    	End With
	
	' Return milliseconds
	GetAudioDuration = audio_length
End Function

'-------------------------------------------------------------------------------
' Plays a section of a specified audio file
'
' Arguments:	file_name	- The name or full path to the file.
'		skip_time	- The number of seconds to skip.
'		play_time	- The number of miliseconds to play the file.
'		volume		- The number of volume to start.
' Returns:   None
'-------------------------------------------------------------------------------
Sub PlayAudio(file_name, skip_time, play_time, volume)
On Error Resume Next
	Dim player	:	Set player = CreateObject("WMPlayer.OCX")		' PLAYER OBJECT
	Dim FSO		:	Set FSO = CreateObject("Scripting.FileSystemObject")	' FILE SYSTEM OBJECT
	Dim oShell	:	Set oShell = CreateObject( "WScript.Shell" )		' SHELL OBJECT
	Dim start_time	' Started time
	Dim end_time	' End time
	Dim pelapsed	' Previous elapsed time
	Dim content
	play_time = play_time * 1000	' Converts the end time to miliseconds


	With player
		.URL = file_name
		.settings.volume = volume
		With .Controls
			' Play the audio
			.CurrentPosition = skip_time
			.Play

			' Wait til the file it's loaded.
			' Translation: Do While file isn't playing
			Do Until player.playState = 3
				' Calculating the start - end time to check by an "elapsed" time
				' This avoid use WScript.Sleep command so the script will still running.
				start_time = Round(Timer)
				end_time = ((start_time + play_time) - start_time) / 1000

				' Wait till file is loading
				WScript.Sleep 50
			Loop

			' Check the pause and volume files always while the time still under the end time.
			Do While end_time >= (Round(Timer) - start_time)

				' If exist "pause.f" File Then check if the song is already playing
				' If it's playing stops, if isn't then plays.
				if FSO.FileExists(FSO.GetParentFolderName(WScript.ScriptFullName) & "\pause.f") Then
					if player.playState = 3 Then
						FSO.DeleteFile(FSO.GetParentFolderName(WScript.ScriptFullName) & "\pause.f")
						.Pause
					elseif player.playState = 2 Then
						FSO.DeleteFile(FSO.GetParentFolderName(WScript.ScriptFullName) & "\pause.f")
						.Play
					End If
				End If

				' Check for volume file then get the first line and set the volume to that number.
				if FSO.FileExists(FSO.GetParentFolderName(WScript.ScriptFullName) & "\volume.f") Then
					if FSO.GetFile(FSO.GetParentFolderName(WScript.ScriptFullName) & "\volume.f").Size > 0 Then
						content = FSO.GetFile(FSO.GetParentFolderName(WScript.ScriptFullName) & "\volume.f").OpenAsTextStream(1,0).Readline
						if content > 100 Then content = 100
						if content < 0 Then content = 0
						player.settings.volume = content
					End If
				End If
				' If the music it's paused then recalculate the end time.
				if player.playState = 2 Then
					if pelapsed <> (Round(Timer) - start_time) Then end_time = end_time + 1
				End If
				pelapsed = (Round(Timer) - start_time)

			Loop

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

Dim filename, start_time, duration, volume

' Process arguments and set any non-default values
With WScript
	If .Arguments.Count = 0 Then Usage
	filename = .Arguments(0)
	start_time = 0
	volume = 100
	duration = GetAudioDuration(filename)
	If .Arguments.Count > 1 Then start_time = .Arguments(1)
	If .Arguments.Count > 2 Then duration = .Arguments(2)
	If .Arguments.Count > 3 Then volume = .Arguments(3)
	If volume > 100 Then volume = 100
End With

Call PlayAudio(filename, start_time, duration, volume)
