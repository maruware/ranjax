require 'natto'

class Ranjax
  END_OF_TEXT = '__E__'
  @words = []
  @head_idxs = []

  def initialize()
    @words = []
    @head_idxs = []
  end

  def import_text(text)
    nm = Natto::MeCab.new

    words = []
    nm.parse(text) do |n|
      words << n.surface
    end
    words << END_OF_TEXT

    @head_idxs << @words.size
    @words += words
  end

  def generate_text(max: nil)
    units = []
    @words.each_cons(3) do |unit|
      units << unit
    end

    head_idx= @head_idxs.sample
    t1 = units[head_idx][0]
    t2 = units[head_idx][1]

    dst_text = t1 + t2
    loop do
      candidate_units = []
      units.each do |unit|
        candidate_units << unit if unit[0] == t1 && unit[1] == t2
      end

      break if candidate_units.size == 0

      unit = candidate_units.sample

      break if max != nil && dst_text.size + unit[2].size > max

      break if unit[2] == END_OF_TEXT

      dst_text += unit[2]

      t1 = unit[1]
      t2 = unit[2]
    end

    dst_text
  end

end
