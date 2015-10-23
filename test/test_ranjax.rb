$: << 'lib'
require 'minitest'
require 'minitest/autorun'

require 'ranjax'

class RanjaxTest < MiniTest::Test
  def setup
    @texts = []
    @texts << <<EOS
日本語（にほんご、にっぽんご）は、主に日本国内や日本人同士の間で使われている言語である。日本は法令によって「公用語」を規定していないが、法令その他の公用文は全て日本語で記述され、各種法令（裁判所法第74条、会社計算規則第57条、特許法施行規則第2条など）において日本語を用いることが定められるなど事実上の公用語となっており、学校教育の「国語」でも教えられる。
使用人口について正確な統計はないが、日本国内の人口、および日本国外に住む日本人や日系人、日本がかつて統治した地域の一部の住民など、約1億3千万人以上と考えられている。統計によって前後する可能性はあるが、この数は世界の母語話者数で上位10位以内に入る人数である。
日本で生まれ育ったほとんどの人は、日本語を母語とする。日本語の文法体系や音韻体系を反映する手話として日本語対応手話がある。
2013年1月現在、インターネット上の言語使用者数は、英語、中国語、スペイン語、アラビア語、ポルトガル語に次いで6番目に多い。
EOS
    @texts << <<EOS
日本語は、主に日本国内で使用される。話者人口についての調査は国内・国外を問わず未だないが、日本の人口に基づいて考えられることが一般的である。
日本国内に、法令上、日本語を公用語ないし国語と定める直接の規定はない。しかし、そもそも法令は日本語で記されており、裁判所法においては「裁判所では、日本語を用いる」（同法74条）とされ、文字・活字文化振興法においては「国語」と「日本語」が同一視されており（同法3条、9条）、その他多くの法令において、日本語が唯一の公用語ないし国語であることが当然の前提とされている。また、法文だけでなく公用文はすべて日本語のみが用いられ、学校教育では日本語が「国語」として教えられている。
EOS
  end

  def test_simple_usage
    text = @texts[0]

    ranjax = Ranjax.new()
    ranjax.import_text(text)

    text = ranjax.generate_text()
    assert_instance_of String, text
  end

  def test_generate_text_max_length()
    text = @texts[0]

    ranjax = Ranjax.new()
    ranjax.import_text(text)
    text = ranjax.generate_text(max: 140)
    assert text.size <= 140
  end

  def test_multi_import_text
    text = @texts[0]

    ranjax = Ranjax.new()
    ranjax.import_text(text)

    text = @texts[1]

    ranjax = Ranjax.new()
    ranjax.import_text(text)

    text = ranjax.generate_text()
    assert_instance_of String, text
  end

  def test_save
    text = @texts[0]

    ranjax = Ranjax.new()
    ranjax.import_text(text)

    file = Tempfile.new('test')
    ranjax.save(file.path)

    content = File.read(file.path)
    assert content.size > 0
  end

  def test_load
    text = @texts[0]

    ranjax = Ranjax.new()
    ranjax.import_text(text)

    file = Tempfile.new('test')
    ranjax.save(file.path)

    ranjax = Ranjax.new(path: file.path)
    text = ranjax.generate_text()
    assert_instance_of String, text

  end

  def test_import_text_file
    file_path = File.dirname(__FILE__) + '/data/texts.txt'

    ranjax = Ranjax.new()
    ranjax.import_text_file(file_path)

    text = ranjax.generate_text()
    assert_instance_of String, text
  p text
  end

end
