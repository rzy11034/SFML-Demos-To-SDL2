﻿//
// SFML/CSFML Audio.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at https://www.djmaster.com/
//

////////////////////////////////////////////////////////////
//
// SFML - Simple and Fast Multimedia Library
// Copyright (C) 2007-2018 Laurent Gomila (laurent@sfml-dev.org)
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it freely,
// subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented;
//    you must not claim that you wrote the original software.
//    If you use this software in a product, an acknowledgment
//    in the product documentation would be appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such,
//    and must not be misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source distribution.
//
////////////////////////////////////////////////////////////

// #ifndef SFML_SOUNDBUFFER_H
// #define SFML_SOUNDBUFFER_H

////////////////////////////////////////////////////////////
// Headers
////////////////////////////////////////////////////////////
// #include </Audio/Export.h>
// #include </Audio/Types.h>
// #include </System/InputStream.h>
// #include </System/Time.h>
// #include <stddef.h>

(*
  \brief Create a new sound buffer and load it from a file

  Here is a complete list of all the supported audio formats:
  ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
  w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.

  \param filename Path of the sound file to load

  \return A new sfSoundBuffer object (NULL if failed)
*)
function sfSoundBuffer_createFromFile(const filename: pchar): PsfSoundBuffer; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Create a new sound buffer and load it from a file in memory

  Here is a complete list of all the supported audio formats:
  ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
  w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.

  \param data        Pointer to the file data in memory
  \param sizeInBytes Size of the data to load, in bytes

  \return A new sfSoundBuffer object (NULL if failed)
*)
function sfSoundBuffer_createFromMemory(const data: pointer; sizeInBytes: csize_t): PsfSoundBuffer; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Create a new sound buffer and load it from a custom stream

  Here is a complete list of all the supported audio formats:
  ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
  w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.

  \param stream Source stream to read from

  \return A new sfSoundBuffer object (NULL if failed)
*)
function sfSoundBuffer_createFromStream(stream: PsfInputStream): PsfSoundBuffer; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Create a new sound buffer and load it from an array of samples in memory

  The assumed format of the audio samples is 16 bits signed integer
  (sfInt16).

  \param samples      Pointer to the array of samples in memory
  \param sampleCount  Number of samples in the array
  \param channelCount Number of channels (1 = mono, 2 = stereo, ...)
  \param sampleRate   Sample rate (number of samples to play per second)

  \return A new sfSoundBuffer object (NULL if failed)
*)
function sfSoundBuffer_createFromSamples(const samples: PsfInt16; sampleCount: sfUint64; channelCount: cuint; sampleRate: cuint): PsfSoundBuffer; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Create a new sound buffer by copying an existing one

  \param soundBuffer Sound buffer to copy

  \return A new sfSoundBuffer object which is a copy of \a soundBuffer
*)
function sfSoundBuffer_copy(const soundBuffer: PsfSoundBuffer): PsfSoundBuffer; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Destroy a sound buffer

  \param soundBuffer Sound buffer to destroy
*)
procedure sfSoundBuffer_destroy(soundBuffer: PsfSoundBuffer); cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Save a sound buffer to an audio file

  Here is a complete list of all the supported audio formats:
  ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
  w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.

  \param soundBuffer Sound buffer object
  \param filename    Path of the sound file to write

  \return sfTrue if saving succeeded, sfFalse if it failed
*)
function sfSoundBuffer_saveToFile(const soundBuffer: PsfSoundBuffer; const filename: pchar): sfBool; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Get the array of audio samples stored in a sound buffer

  The format of the returned samples is 16 bits signed integer
  (sfInt16). The total number of samples in this array
  is given by the sfSoundBuffer_getSampleCount function.

  \param soundBuffer Sound buffer object

  \return Read-only pointer to the array of sound samples
*)
function sfSoundBuffer_getSamples(const soundBuffer: PsfSoundBuffer): PsfInt16; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Get the number of samples stored in a sound buffer

  The array of samples can be accessed with the
  sfSoundBuffer_getSamples function.

  \param soundBuffer Sound buffer object

  \return Number of samples
*)
function sfSoundBuffer_getSampleCount(const soundBuffer: PsfSoundBuffer): sfUint64; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Get the sample rate of a sound buffer

  The sample rate is the number of samples played per second.
  The higher, the better the quality (for example, 44100
  samples/s is CD quality).

  \param soundBuffer Sound buffer object

  \return Sample rate (number of samples per second)
*)
function sfSoundBuffer_getSampleRate(const soundBuffer: PsfSoundBuffer): cuint; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Get the number of channels used by a sound buffer

  If the sound is mono then the number of channels will
  be 1, 2 for stereo, etc.

  \param soundBuffer Sound buffer object

  \return Number of channels
*)
function sfSoundBuffer_getChannelCount(const soundBuffer: PsfSoundBuffer): cuint; cdecl; external LIB_CSFMLAUDIO;

(*
  \brief Get the total duration of a sound buffer

  \param soundBuffer Sound buffer object

  \return Sound duration
*)
function sfSoundBuffer_getDuration(const soundBuffer: PsfSoundBuffer): sfTime; cdecl; external LIB_CSFMLAUDIO;

// #endif // SFML_SOUNDBUFFER_H
