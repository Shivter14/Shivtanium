'-------------------------------------------------------------------------------------------------------------------------
' USAGE:
'	<filename>.vbs [-play filename][-gettime filename][-start seconds][-end seconds][-volume volume][-getcurrent]
'
' DESCRIPTION
'     Plays a snippet of an audio file.
'     Based on the same few snippets that can be found everywhere online.
'
' AUTHOR
'     sintrode, modified by RazorArt, versioning fixed by Shivter
'
'	VERSION	DATE		AUTHOR		DESCRIPTION
'	---	----------	--------	--------------------------------------------------------------------------
'	1.5	2024-07-29	RazorArt	- Clean up the code.
'
'	1.4	2024-07-26	RazorArt	- Added time format function (stackoverflow)
'						- Added New Parameter system
'						- Added [-gettime] parameter.
'						- Added play/resume function.
'						- Added [-getcurrent] time while playing parameter.
'						- Added [-volume] parameter.
'						- Added [-start] parameter.
'						- Added [-end] parameter.
'						- Added force exit function.
'						- Added volume while playing function.
'						- Added seek while playing function.
'						- Changed usage message.
'
'	1.3	2024-07-25	RazorArt	- Added [-gettime] function.
'
'	1.2	2024-07-24	RazorArt	- Added volume, pause and resume.
'
'	1.1	2018-08-29	sintrode	- Added mandatory and optional arguments
'						- Reorganized code to use subroutines
'	1.0	2018-08-28	sintrode	- Initial version
'
'-------------------------------------------------------------------------------------------------------------------------
Option Explicit

'┌─────────────────────────────────────────────┐
'│                    USAGE                    │
'└─────────────────────────────────────────────┘
'
' Display the usage message
Sub Usage
	With WScript
		.Echo "Play Snippet (v1.5)" & vbCrLf & "-Original file created by Sintrode. Modified by RazorArt" & vbCrLf & vbCrLf
		.Echo "Usage:" & vbCrLf & "	Ply.vbs [-play filename] [-gettime filename] [-start seconds] [-end seconds] [-volume] [-getcurrent]"& vbCrLf
		.Echo "[REQUIRED]:"& vbCrLf
		.Echo "-play filename		- Play's the [filename required] music file." & vbCrLf
		.Echo "[OPTIONALS]:"& vbCrLf
		.Echo "-gettime filename	- Get the [filename required] music file duration" & _
					vbCrLf & "			The duration will be write on a text file named [duration.f]" & _
					vbCrLf & "			with the [hours:minutes:seconds] format" & vbCrLf
		.Echo "-start seconds		- Start the music at [seconds required] time" & _
					vbCrLf & "			Seconds must be an integer." & _
					vbCrLf & "			By default = 0." & vbCrLf
		.Echo "-end seconds		- Ends the music at [seconds required] time" & _
					vbCrLf & "			Seconds must be an integer." & _
					vbCrLf & "			By default = Song duration." & vbCrLf
		.Echo "-volume volume		- The number of start volume" & _
					vbCrLf & "			Volume must be an integer from 0 to 100" & _
					vbCrLf & "			By default = 50." & vbCrLf
		.Echo "-getcurrent		- Get the elapsed time of the song while playing" & _
					vbCrLf & "			The current time will be write on a text file named [currenttime.f]" & _
					vbCrLf & "			with the [hours:minutes:seconds] format" & vbCrLf
		.Echo "[FUNCTIONS]:"& vbCrLf
		.Echo "Pause/resume		-Create a file named [pause.f] in the ply.vbs location to pause or resume."& vbCrLf
		.Echo "Change volume		-Create a file named [volume.f] in the ply.vbs location what contains" & _
					vbCrLf & "			the volume value to change (from 0 to 100)" & vbCrLf
		.Echo "Seek			-Create a file named [seek.f] in the ply.vbs location what contains" &_
					vbCrLf & "			the seek time in seconds the format will be [+seconds] or [-seconds]" &_
					vbCrLf & "			this will add or substract the [seek time] to the current playing time" & vbCrLf
		.Echo "Force Exit		-Create a file named [exit.f] in the ply.vbs location to force close the music player."
		.Quit
	End With
End Sub

'┌───────────────────────────────────────────┐
'│               FORCE CSCRIPT               │
'└───────────────────────────────────────────┘
' Forces the use of cscript so that the usage message doesn't get displayed as a series of messageboxes
'
' Source:    https://stackoverflow.com/a/5219524/4158862
' Arguments: None
' Returns:   None

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

'┌────────────────────────────────────────────────┐
'│               GET AUDIO DURATION               │
'└────────────────────────────────────────────────┘
' Gets the duration of the file and returns it in milliseconds
'
' Source:	'https://stackoverflow.com/a/19812711/4158862
' Arguments:	filename (Audio file name).
' Returns:	The duration of the audio.

Function GetAudioDuration(filename)
	Dim audio_length	'	Audio lenght variable.

	' Load the audio and set the audio_length variable.
	With CreateObject("WMPlayer.OCX")
        	.settings.mute = True
        	.url = filename
		
		' This forces the script to wait til the music file it's loaded.
		' Translation: Do While file isn't playing: wait 50ms then repeat
        	Do While Not .playState = 3
          		  WScript.Sleep 50
       		Loop
	' Set audio_length variable to the duration of the music file.
        audio_length = .currentMedia.duration
        .Close 
    	End With
	
	' Returns the duration without format
	GetAudioDuration = audio_length
End Function

'┌─────────────────────────────────────────┐
'│               FORMAT TIME               │
'└─────────────────────────────────────────┘
' Recibe a time as input and returns [h:m:s]
' https://stackoverflow.com/questions/38139824/how-to-convert-timer-value-to-minutes-and-seconds

Function FormatTime(secs)
	Dim t, a
	secs = Int(secs)
	a = Array(CStr(Right("00" & Int(secs / 3600) Mod 24, 2)), CStr(Right("00" & Int(secs / 60) Mod 60, 2)), CStr(Right("00" & secs Mod 60, 2)))
	FormatTime = Join(a, ":")
End Function

'┌────────────────────────────────────────┐
'│               PLAY AUDIO               │
'└────────────────────────────────────────┘
' Plays a section of a specified audio file
'
' Arguments:	filename	- The name or full path to the file.
'		start_time	- The number of seconds to skip.
'		end_time	- The number of miliseconds to play the file.
'		volume		- The number of volume to start.
'		ctime		- A bool, True = Write current time to a file.
'
' Returns:	None

Sub PlayAudio(filename, start_time, end_time, volume, ctime)
On Error Resume Next
	Dim player	:	Set player = CreateObject("WMPlayer.OCX")		' PLAYER OBJECT
	Dim fso		:	Set fso = CreateObject("Scripting.FileSystemObject")	' FILE SYSTEM OBJECT
	Dim oShell	:	Set oShell = CreateObject( "WScript.Shell" )		' SHELL OBJECT
	Dim sttime	' Started time
	Dim entime	' End time
	Dim elapsed	' Elapsed time
	Dim pelapsed	' Previous elapsed time
	Dim pelap	' Paused Elapsed time
	Dim seek	' Seek
	Dim seektf	:	seektf = 0	' Seek time forward
	Dim seektb	:	seektb = 0	' Seek time backward

	With player
		.URL = filename			' Set the current song to the specified file.
		.settings.volume = volume	' Set the volume to specified value.
		With .Controls

			.CurrentPosition = start_time	' Set the current position of the player to specified position.
			.Play

			' Wait til the file it's loaded.
			' Translation: Do While file isn't playing.
			Do Until player.playState = 3

				sttime = timer			' Set start time to current time.
				entime = end_time * 1000	' Set end time to specified in miliseconds.
				elapsed = 0			' Set elapsed time to 0
				pelapsed = 0			' Set previous elapsed time to 0
				pelap = 0			' Set Paused elapsed time to 0
				seek = 0			' Set Seek time to 0

				' Wait till file is loading
				WScript.Sleep 50
			Loop

			' Do until the time elapsed reach the specified end time.
			Do Until entime < elapsed

				' Calculate elapsed time (minus the time elapsed while was paused)
				elapsed = ((timer - sttime) * 1000) - pelap

				' If is defined seek time forward then seek forward
				if seektf > 0 Then elapsed = elapsed + seektf

				' If is defined seek time backward then seek backward
				if seektb > 0 Then elapsed = elapsed - seektb

				' If music is paused.
				If player.playState = 2 Then

					' Check for the pause file to resume.
					If fso.FileExists(fso.GetParentFolderName(WScript.ScriptFullName) & "\pause.f") Then
						.Play
						fso.DeleteFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\pause.f")
					End If
					' add to paused elapsed time 100 ms
					pelap = pelap + 100
				End If

				' If Elapsed time changed
				If elapsed <> pelapsed Then

					' If music it's playing
					If player.playState = 3 Then

						' Create a file [currenttime.f] with the current playing time if -getcurrent was specified.
						If ctime = true Then
							fso.CreateTextFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\currenttime.f",True).Write FormatTime(elapsed / 1000)
							WScript.Echo FormatTime(elapsed / 1000)
						End If

						' -----------------------------------------------------------------------------------
						' Check for the pause file to pause.
						' -----------------------------------------------------------------------------------
						If fso.FileExists(fso.GetParentFolderName(WScript.ScriptFullName) & "\pause.f") Then
							.Pause
							fso.DeleteFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\pause.f")
						End If
						' -----------------------------------------------------------------------------------

						' -----------------------------------------------------------------------------------
						' Check for the exit file to force close.
						' -----------------------------------------------------------------------------------
						If fso.FileExists(fso.GetParentFolderName(WScript.ScriptFullName) & "\exit.f") Then
							fso.DeleteFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\exit.f")
							.Stop
							player.Close
							WScript.Quit
						End If
						' -----------------------------------------------------------------------------------
						' -----------------------------------------------------------------------------------
						' Check for the seek file.
						' -----------------------------------------------------------------------------------
						If fso.FileExists(fso.GetParentFolderName(WScript.ScriptFullName) & "\seek.f") Then
							If fso.GetFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\seek.f").Size > 0 Then
								seek = fso.GetFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\seek.f").OpenAsTextStream(1,0).Readline
								.Pause
								if seek > 0 Then
									if (elapsed + (seektf + (seek * 1000))) >= entime Then
										fso.CreateTextFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\exit.f",True).Write "f"
									else
										.CurrentPosition = (elapsed / 1000) + seek
										seektf = seektf + (seek * 1000)
										seektb = seektb - (seek * 1000)
										seek = 0
									End If
								End If
								if seek < 0 Then
									if ((((timer - sttime) * 1000) - pelap) - (seektb + ((seek * 1000)*-1))) <= 0 Then
										.CurrentPosition = 0
										seektb = ((timer - sttime) * 1000) - pelap
										seektf = seektf - ((seek * 1000)*-1)
										seek = 0

									else
										.CurrentPosition = (elapsed / 1000)-(seek)*-1
										seektb = seektb + ((seek * 1000)*-1)
										seektf = seektf - ((seek * 1000)*-1)
										seek = 0
									End If
								End If
								.Play
								fso.DeleteFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\seek.f")
							End If
						End If
						' -----------------------------------------------------------------------------------

						' -----------------------------------------------------------------------------------
						' Check for the volume file.
						' -----------------------------------------------------------------------------------
						If fso.FileExists(fso.GetParentFolderName(WScript.ScriptFullName) & "\volume.f") Then
							If fso.GetFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\volume.f").Size > 0 Then
								volume = fso.GetFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\volume.f").OpenAsTextStream(1,0).Readline
								if volume > 100 Then volume = 100
								if volume < 0 Then volume = 0
								player.settings.volume = volume
							End If
						End If
						' -----------------------------------------------------------------------------------

					End If


				End If
				WScript.Sleep 100

				' Set previous elapsed time to elapsed time
				pelapsed = elapsed
			Loop
			.Stop
		End With
		.Close
	End With
End Sub

'┌──────────────────────────────────────────┐
'│               MAIN SECTION               │
'└──────────────────────────────────────────┘
' Main .vbs what handle the parameters and run the commands.

ForceCscript

Dim arg		:	arg = 0							'	Argument number to iterate.
Dim fso		:	Set fso = CreateObject("Scripting.FileSystemObject")	'	FILE SYSTEM OBJECT

Dim filename, start_time, end_time, volume, ctime

With WScript

	' [NO INPUT] Error.
	If .Arguments.Count = 0 Then
		.Echo "[Ply.vbs]: No input."
		Usage
		.Quit
	End If

	' Iterate through all arguments.
	Do while arg < .Arguments.Count


		'┌─────────────────────┐
		'│     -GETCURRENT     │
		'└─────────────────────┘
		If LCase(.Arguments(arg)) = "-getcurrent" Then
			ctime = True
		End If


		'┌──────────────────┐
		'│     -GETTIME     │
		'└──────────────────┘
		If LCase(.Arguments(arg)) = "-gettime" Then

			' Check if defined a file.
			If (arg + 1) >= (.Arguments.Count) Then
				.Echo "[Ply.vbs]: No input file."
				.Quit
			End If
			' Check if file exist then get duration.
			If fso.FileExists(.Arguments(arg + 1)) Then
				' Creates "duration.f" file what contains song duration.
				fso.CreateTextFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\duration.f",True).Write FormatTime(GetAudioDuration(.Arguments(arg+1)))
			else
				.Echo "[Ply.vbs]: Specified file [" & .Arguments(arg+1) & "] Doesn't exist."
				.Quit
			End If
		End If
		'┌───────────────┐
		'│     -PLAY     │
		'└───────────────┘
		If LCase(.Arguments(arg)) = "-play" Then
			' Check if defined a file.
			If (arg + 1) >= (.Arguments.Count) Then
				.Echo "[Ply.vbs]: No input file."
				.Quit
			End If
			' Check if file exist then get duration.
			If fso.FileExists(.Arguments(arg + 1)) Then
				filename = .Arguments(arg + 1)
			else
				.Echo "[Ply.vbs]: Specified file [" & .Arguments(arg+1) & "] Doesn't exist."
				.Quit
			End If
		End If
		'┌────────────────┐
		'│     -START     │
		'└────────────────┘
		If LCase(.Arguments(arg)) = "-start" Then
			' Check if -start value is defined.
			If (arg + 1) >= (.Arguments.Count) Then
				.Echo "[Ply.vbs]: No start time specified."
				.Quit
			End If
			' Check if -start value is numeric.
			If IsNumeric(.Arguments(arg+1)) Then
				start_time = .Arguments(arg+1)
			else
				.Echo "[Ply.vbs]: Error, start time must be numeric."
				.Quit
			End If
		End If
		'┌──────────────┐
		'│     -END     │
		'└──────────────┘
		If LCase(.Arguments(arg)) = "-end" Then
			' Check if -end value is defined.
			If (arg + 1) >= (.Arguments.Count) Then
				.Echo "[Ply.vbs]: No end time specified."
				.Quit
			End If
			' Check if -end value is numeric.
			If IsNumeric(.Arguments(arg+1)) Then
				end_time = .Arguments(arg+1)
			else
				.Echo "[Ply.vbs]: Error, end time must be numeric."
				.Quit
			End If
		End If
		'┌─────────────────┐
		'│     -VOLUME     │
		'└─────────────────┘
		If LCase(.Arguments(arg)) = "-volume" Then
			' Check if -volume value is defined.
			If (arg + 1) >= (.Arguments.Count) Then
				.Echo "[Ply.vbs]: No volume value specified."
				.Quit
			End If
			' Check if -volume value is numeric.
			If IsNumeric(.Arguments(arg+1)) Then
				If .Arguments(arg+1) >= 100 Then
					volume = 100
				elseif .Arguments(arg+1) <= 0 Then
					volume = 0
				else
					volume = .Arguments(arg+1)
				End If
			else
				.Echo "[Ply.vbs]: Error, volume value must be numeric."
				.Quit
			End If
		End If
		arg = arg + 1
	Loop
End With

'┌─────────────────────────────────────┐
'│     Check vars and set defaults     │
'└─────────────────────────────────────┘
If IsEmpty(filename) Then
	WScript.Echo "[Ply.vbs]: Error, file must be specified."
	WScript.Quit
End If

If IsEmpty(start_time) Then start_time = 0
If IsEmpty(end_time) Then end_time = GetAudioDuration(filename)
If IsEmpty(volume) Then volume = 50
If IsEmpty(ctime) Then ctime = false


Call PlayAudio(filename, start_time, end_time, volume, ctime)
