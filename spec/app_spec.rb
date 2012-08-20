require 'spotify_to_mp3'
require 'tempfile'

module SpotifyToMp3
  class App
    describe App do
      before(:each) do
        @app = DependencyInjection.new.app
      end

      context "#file_track_ids" do
        it "reads lines" do
          open_test_file("1\n2\n3") do |file|
            file_track_ids_count(file).should == 3
          end
        end

        it "trims spaces" do
          open_test_file(" 1 ") do |file|
            @app.file_track_ids(file) do |track_id|
              track_id.should == "1"
            end
          end
        end

        it "ignores empty lines" do
          open_test_file("1\n\n2\n") do |file|
            file_track_ids_count(file).should == 2
          end
        end
      end

      def open_test_file(content)
        Tempfile.open('tracks') do |file|
          file.write(content)
          file.rewind
          yield file
        end
      end

      def file_track_ids_count(file)
        count = 0
        @app.file_track_ids(file) do |track_id| count += 1 end
        count
      end
    end
  end
end