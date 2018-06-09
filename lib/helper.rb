module Helper

  def falsey_answer?(answer)
    ['no', 'n', 'No', 'N'].include? answer
  end

  def headerize(text)
    puts "\n"
    text.length.times { print "=" }
    puts "\n#{text}"
    text.length.times { print "=" }
    puts "\n\n"
  end

end

class String
  def to_titlecase
    self.split(/(\W)/).select{|a| a != " "}.map(&:capitalize).join
  end
end
