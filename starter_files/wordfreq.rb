require 'csv'

class Wordfreq
  STOP_WORDS = ['a', 'an', 'and', 'are', 'as', 'at', 'be', 'by', 'for', 'from',
    'has', 'he', 'i', 'in', 'is', 'it', 'its', 'of', 'on', 'that', 'the', 'to',
    'were', 'will', 'with']

    def initialize(filename)
      @contents = File.read(filename)

      @array = @contents.gsub(/\W+/, " " ).split(" ")

      @array = @array.select do |el|
        if !STOP_WORDS.index(el.downcase)
          el
        end
      end
      print @array
    end

  def frequency(word)
    index = 0
    used = []
    @contents.each_char do |c|
    otherIndex = word.length + index
      if @contents[index ... (otherIndex)] == word && (!@contents[index-1].match(/^[[:alpha:]]$/) && !@contents[otherIndex].match(/^[[:alpha:]]$/))
        used.push(word)
      end
      index += 1
    end
    used.length
  end

  def frequencies
    output = {}
    @array.each do |el|
      if output.has_key?(el)
        value = output[el]
        value += 1
        output[el] = value
      else
        output[el] = 1
      end
    end
    output
  end

  def top_words(number)
    frequencyArray = frequencies
    output = frequencyArray.sort_by { |key, value| value }.reverse.take(number)
    output
  end

  def print_report
    output = []
    sortedFrequencyArray = top_words(10)
    sortedFrequencyArray.each do |el|
      output.push( "#{el[0]} | #{el[1]} " + "*" * el[1])
    end
    puts output
  end

if __FILE__ == $0
  filename = ARGV[0]
  if filename
    full_filename = File.absolute_path(filename)
    if File.exists?(full_filename)
      wf = Wordfreq.new(full_filename)
      wf.print_report
    else
      puts "  #{filename} does not exist!"
    end
  else
    puts "Please give a filename as an argument."
  end
end

end
