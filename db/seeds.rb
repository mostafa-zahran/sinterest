# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin_user = User.create(name: 'Administrator', admin: true, email: 'admin@sinterest.com', password: '123456789', password_confirmation: '123456789')
normal_user = User.create(name: 'Test User', admin: false, email: 'test_user1@sinterest.com', password: '123456789', password_confirmation: '123456789')
track_file = Rails.root.join('spec/dog_puppy.wav').open
admin_track = Track.create(name: 'Track1', user: admin_user, sound_track: track_file)
normal_track = Track.create(name: 'Track2', user: normal_user, sound_track: track_file)
admin_playlist = Playlist.create(name: 'Playlist1', user: admin_user, tracks: [admin_track])
normal_playlist = Playlist.create(name: 'Playlist2', user: normal_user, tracks: [normal_track])