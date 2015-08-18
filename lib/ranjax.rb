require 'natto'

class Ranjax
  END_OF_TEXT = '__E__'
  END_MARKERS = ['。', '！', '!']
  @words = []
  @head_idxs = []

  def initialize(path: nil)
    @words = []
    @head_idxs = []

    unless path.nil?
      load(path)
    end
  end

  def import_text(text)
    nm = Natto::MeCab.new

    words = []
    nm.parse(text) do |n|
      words << n.surface if n.surface.size > 0
    end
    words << END_OF_TEXT

    @head_idxs << @words.size
    @words += words
  end

  def generate_text(max: nil, complete_if_possible:true)
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

      if max != nil && dst_text.size + unit[2].size > max
        if complete_if_possible
          g = END_MARKERS.join('')
          idx = dst_text.rindex(/[#{g}]/)
          if idx
            dst_text.slice!(idx+1, dst_text.size-1)
          end
        end
        break
      end

      break if unit[2] == END_OF_TEXT

      dst_text += unit[2]

      t1 = unit[1]
      t2 = unit[2]
    end

    dst_text
  end

  def save(path)
    if path.empty?
      raise ArgumentError.new('Bad Path')
    end

    data = Marshal.dump({
      :words=>@words,
      :head_idxs=>@head_idxs
    })
    File.write(path, data)
  end

  private

  def load(path)
    r = File.read(path)
    data = Marshal.load(r)
    @words = data[:words]
    @head_idxs = data[:head_idxs]
  end

end
