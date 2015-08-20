require 'csv'
require 'zip'
# require 'pry'

class ParserService
  NAMES = %w(Account Activity Position Security)
  FILE = 'public/Ruby test task.zip'

  def initialize
    @data = {}
  end

  def run(file)
    unzip(file)
    @data
  end

  private

  def unzip(file)
    file = FILE if file == ''
    begin
      Zip::File.open(file) do |zip_file|
        names = select_file_names zip_file.glob('*.txt').map(&:name)
        names.each { |name| parse name }
      end
    rescue Zip::Error => e
      @data[:errors] = e.message
    end
  end

  def parse(name)
    set_data name[0..-5].split(/_/)
  end

  def set_data(args)
    id, type, date = args[0], args[1], args[2]
    if @data[id]
      @data[id][date] ? @data[id][date] << type : @data[id][date] = [type]
    else
      @data[id] = {date => [type]}
    end
  end

  def select_file_names(files)
    #no exception logging (rendering), monkey handling
    files.select do |file|
      match_data = file.match(pattern)
      Date.strptime match_data[2], '%Y%m%d' rescue nil
    end
  end

  def pattern
    Regexp.new "[A-Z]\\d+_(#{NAMES.join('|')})_(\\d{8}).txt"
  end
end