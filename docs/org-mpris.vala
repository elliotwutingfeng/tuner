/**
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file org-mpris.vala
 * @brief 
 */

/* Generated by vala-dbus-binding-tool 0.4.0. Do not modify! */
/* Generated with: vala-dbus-binding-tool --api-path=../data --directory=../src */
using DBus;
using GLib;

namespace org {

	namespace mpris {

		[DBus (name = "org.mpris.MediaPlayer2.Player", timeout = 120000)]
		public interface MediaPlayer2Player : GLib.Object {

			[DBus (name = "Next")]
			public abstract void next() throws DBus.Error;

			[DBus (name = "Previous")]
			public abstract void previous() throws DBus.Error;

			[DBus (name = "Pause")]
			public abstract void pause() throws DBus.Error;

			[DBus (name = "PlayPause")]
			public abstract void play_pause() throws DBus.Error;

			[DBus (name = "Stop")]
			public abstract void stop() throws DBus.Error;

			[DBus (name = "Play")]
			public abstract void play() throws DBus.Error;

			[DBus (name = "Seek")]
			public abstract void seek(int64 Offset) throws DBus.Error;

			[DBus (name = "SetPosition")]
			public abstract void set_position(DBus.ObjectPath TrackId, int64 Position) throws DBus.Error;

			[DBus (name = "OpenUri")]
			public abstract void open_uri(string Uri) throws DBus.Error;

			[DBus (name = "Seeked")]
			public signal void seeked(int64 Position);

			[DBus (name = "PlaybackStatus")]
			public abstract string playback_status { owned get; set; }

			[DBus (name = "LoopStatus")]
			public abstract string loop_status { owned get; set; }

			[DBus (name = "Rate")]
			public abstract double rate {  get; set; }

			[DBus (name = "Shuffle")]
			public abstract bool shuffle {  get; set; }

			[DBus (name = "Metadata")]
			public abstract GLib.HashTable<string, GLib.Value?> metadata { owned get; set; }

			[DBus (name = "Volume")]
			public abstract double volume {  get; set; }

			[DBus (name = "Position")]
			public abstract int64 position {  get; set; }

			[DBus (name = "MinimumRate")]
			public abstract double minimum_rate {  get; set; }

			[DBus (name = "MaximumRate")]
			public abstract double maximum_rate {  get; set; }

			[DBus (name = "CanGoNext")]
			public abstract bool can_go_next {  get; set; }

			[DBus (name = "CanGoPrevious")]
			public abstract bool can_go_previous {  get; set; }

			[DBus (name = "CanPlay")]
			public abstract bool can_play {  get; set; }

			[DBus (name = "CanPause")]
			public abstract bool can_pause {  get; set; }

			[DBus (name = "CanSeek")]
			public abstract bool can_seek {  get; set; }

			[DBus (name = "CanControl")]
			public abstract bool can_control {  get; set; }
		}

		public MediaPlayer2Player get_media_player2_player_proxy(DBus.Connection con, string busname, DBus.ObjectPath path) {
			return con.get_object(busname, path) as MediaPlayer2Player;
		}
		[DBus (name = "org.mpris.MediaPlayer2.Player", timeout = 120000)]
		public interface MediaPlayer2PlayerSync : GLib.Object {

			[DBus (name = "Next")]
			public abstract void next() throws DBus.Error;

			[DBus (name = "Previous")]
			public abstract void previous() throws DBus.Error;

			[DBus (name = "Pause")]
			public abstract void pause() throws DBus.Error;

			[DBus (name = "PlayPause")]
			public abstract void play_pause() throws DBus.Error;

			[DBus (name = "Stop")]
			public abstract void stop() throws DBus.Error;

			[DBus (name = "Play")]
			public abstract void play() throws DBus.Error;

			[DBus (name = "Seek")]
			public abstract void seek(int64 Offset) throws DBus.Error;

			[DBus (name = "SetPosition")]
			public abstract void set_position(DBus.ObjectPath TrackId, int64 Position) throws DBus.Error;

			[DBus (name = "OpenUri")]
			public abstract void open_uri(string Uri) throws DBus.Error;

			[DBus (name = "Seeked")]
			public signal void seeked(int64 Position);

			[DBus (name = "PlaybackStatus")]
			public abstract string playback_status { owned get; set; }

			[DBus (name = "LoopStatus")]
			public abstract string loop_status { owned get; set; }

			[DBus (name = "Rate")]
			public abstract double rate {  get; set; }

			[DBus (name = "Shuffle")]
			public abstract bool shuffle {  get; set; }

			[DBus (name = "Metadata")]
			public abstract GLib.HashTable<string, GLib.Value?> metadata { owned get; set; }

			[DBus (name = "Volume")]
			public abstract double volume {  get; set; }

			[DBus (name = "Position")]
			public abstract int64 position {  get; set; }

			[DBus (name = "MinimumRate")]
			public abstract double minimum_rate {  get; set; }

			[DBus (name = "MaximumRate")]
			public abstract double maximum_rate {  get; set; }

			[DBus (name = "CanGoNext")]
			public abstract bool can_go_next {  get; set; }

			[DBus (name = "CanGoPrevious")]
			public abstract bool can_go_previous {  get; set; }

			[DBus (name = "CanPlay")]
			public abstract bool can_play {  get; set; }

			[DBus (name = "CanPause")]
			public abstract bool can_pause {  get; set; }

			[DBus (name = "CanSeek")]
			public abstract bool can_seek {  get; set; }

			[DBus (name = "CanControl")]
			public abstract bool can_control {  get; set; }
		}

		public MediaPlayer2PlayerSync get_media_player2_player_sync_proxy(DBus.Connection con, string busname, DBus.ObjectPath path) {
			return con.get_object(busname, path) as MediaPlayer2PlayerSync;
		}
		[DBus (name = "org.mpris.MediaPlayer2", timeout = 120000)]
		public interface MediaPlayer2 : GLib.Object {

			[DBus (name = "Raise")]
			public abstract void raise() throws DBus.Error;

			[DBus (name = "Quit")]
			public abstract void quit() throws DBus.Error;

			[DBus (name = "CanQuit")]
			public abstract bool can_quit {  get; set; }

			[DBus (name = "Fullscreen")]
			public abstract bool fullscreen {  get; set; }

			[DBus (name = "CanSetFullscreen")]
			public abstract bool can_set_fullscreen {  get; set; }

			[DBus (name = "CanRaise")]
			public abstract bool can_raise {  get; set; }

			[DBus (name = "HasTrackList")]
			public abstract bool has_track_list {  get; set; }

			[DBus (name = "Identity")]
			public abstract string identity { owned get; set; }

			[DBus (name = "DesktopEntry")]
			public abstract string desktop_entry { owned get; set; }

			[DBus (name = "SupportedUriSchemes")]
			public abstract string[] supported_uri_schemes { owned get; set; }

			[DBus (name = "SupportedMimeTypes")]
			public abstract string[] supported_mime_types { owned get; set; }
		}

		public MediaPlayer2 get_media_player2_proxy(DBus.Connection con, string busname, DBus.ObjectPath path) {
			return con.get_object(busname, path) as MediaPlayer2;
		}
		[DBus (name = "org.mpris.MediaPlayer2", timeout = 120000)]
		public interface MediaPlayer2Sync : GLib.Object {

			[DBus (name = "Raise")]
			public abstract void raise() throws DBus.Error;

			[DBus (name = "Quit")]
			public abstract void quit() throws DBus.Error;

			[DBus (name = "CanQuit")]
			public abstract bool can_quit {  get; set; }

			[DBus (name = "Fullscreen")]
			public abstract bool fullscreen {  get; set; }

			[DBus (name = "CanSetFullscreen")]
			public abstract bool can_set_fullscreen {  get; set; }

			[DBus (name = "CanRaise")]
			public abstract bool can_raise {  get; set; }

			[DBus (name = "HasTrackList")]
			public abstract bool has_track_list {  get; set; }

			[DBus (name = "Identity")]
			public abstract string identity { owned get; set; }

			[DBus (name = "DesktopEntry")]
			public abstract string desktop_entry { owned get; set; }

			[DBus (name = "SupportedUriSchemes")]
			public abstract string[] supported_uri_schemes { owned get; set; }

			[DBus (name = "SupportedMimeTypes")]
			public abstract string[] supported_mime_types { owned get; set; }
		}

		public MediaPlayer2Sync get_media_player2_sync_proxy(DBus.Connection con, string busname, DBus.ObjectPath path) {
			return con.get_object(busname, path) as MediaPlayer2Sync;
		}	}
}
