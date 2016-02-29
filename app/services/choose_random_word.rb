# Return a random English word from dictionary
class ChooseRandomWord
  WORDS_FILE = "/usr/share/dict/words"
  VALID_WORD_LENGTH_RANGE = 4..9
  
  def call
    words.sample
  end

  private

  def words
    @words ||= begin
      File.readlines(WORDS_FILE)
        .map { |line| line.chomp.downcase }
        .select { |line| VALID_WORD_LENGTH_RANGE.cover?(line.length) }
    end
  end
end

