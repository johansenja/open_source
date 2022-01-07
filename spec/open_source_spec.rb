# frozen_string_literal: true

require_relative "test_file"

TESTING_FILE_PATH = File.join(__dir__, "test_file.rb")

RSpec.describe OpenSource do
  it "has a version number" do
    expect(OpenSource::VERSION).not_to be nil
  end

  describe "#open_source" do
    context "for vim" do
      before { ENV["EDITOR"] = "vim" }

      context "for opening classes" do
        it "accepts the class itself" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+1", TESTING_FILE_PATH)
          open_source(TestingClass)
        end

        it "accepts the class name as a string" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+1", TESTING_FILE_PATH)
          open_source("TestingClass")
        end

        it "raises OpenSource::UnopenableError for non existent classes" do
          expect { open_source "Foo" }.to raise_error OpenSource::UnopenableError
        end

        it "raises OpenSource::UnknownLocationError for native classes" do
          expect { open_source "String" }.to raise_error OpenSource::UnknownLocationError
        end
      end

      context "for opening modules" do
        it "accepts the module itself" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+7", TESTING_FILE_PATH)
          open_source(TestingModule)
        end

        it "accepts the module name as a string" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+7", TESTING_FILE_PATH)
          open_source("TestingModule")
        end

        it "raises OpenSource::UnopenableError for non existent modules" do
          expect { open_source "Foo" }.to raise_error OpenSource::UnopenableError
        end

        it "raises OpenSource::UnknownLocationError for native modules" do
          expect { open_source "Enumerable" }.to raise_error OpenSource::UnknownLocationError
        end
      end

      context "for opening methods" do
        it "accepts them as a string" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+5", TESTING_FILE_PATH)
          open_source("top_level_method")
        end

        it "accepts them as a symbol" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+5", TESTING_FILE_PATH)
          open_source(:top_level_method)
        end

        it "accepts a method itself" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+5", TESTING_FILE_PATH)
          open_source(method(:top_level_method))
        end

        it "raises OpenSource::UnopenableError for non existent methods" do
          expect { open_source "foo" }.to raise_error OpenSource::UnopenableError
        end
      end

      context "for opening unbound methods" do
        it "accepts an unbound method itself" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("vim", "+2", TESTING_FILE_PATH)
          open_source(TestingClass.instance_method(:a))
        end
      end
    end

    context "for vscode" do
      before { ENV["EDITOR"] = "code" }

      context "for opening classes" do
        it "accepts the class itself" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("code", "--goto", "#{TESTING_FILE_PATH}:1")
          open_source(TestingClass)
        end

        it "accepts the class name as a string" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("code", "--goto", "#{TESTING_FILE_PATH}:1")
          open_source("TestingClass")
        end
      end

      context "for opening modules" do
        it "accepts the module itself" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("code", "--goto", "#{TESTING_FILE_PATH}:7")
          open_source(TestingModule)
        end

        it "accepts the module name as a string" do
          expect(OpenSource::Utils::Runner).to receive(:run).with("code", "--goto", "#{TESTING_FILE_PATH}:7")
          open_source("TestingModule")
        end
      end
    end
  end
end
