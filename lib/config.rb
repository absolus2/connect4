require 'yaml'

module Initials
  
  def save_config
    Dir.mkdir('config') unless Dir.exist?('config')
    init = { :board => @board, :null => @null , :player1 => @player1 , :player2 => @player2, :turn => @turn }
    File.open('config/config.yml', 'w') { |file| file.write(YAML.dump(init.to_yaml)) } unless File.exist?('config/config.yml')
  end

  def save_game
    Dir.mkdir('Saves') unless Dir.exist?('Saves')
    init = { :board => @board, :null => @null , :player1 => @player1, :player2 => @player2, :turn => @turn }
    File.open("Saves/#{Time.now.strftime('%d-%m-%Y %H;%M')}.yml", 'w') { |file| file.write(YAML.dump(init.to_yaml)) }
    puts 'The game has been save succesfully'
  end

  def load_game(game)
    saved = Dir.entries('Saves') if Dir.exist?('Saves')

    file_data = YAML.safe_load(File.read("Saves/#{game}"), permitted_classes: [Symbol])

    @board = file_data[:board]
    @turn = file_data[:turn]
  end

  def check_load
    return unless Dir.entries('Saves').length >= 1

    puts 'We were able to find Saved games, Would you like to load them?(Y/N)'
    answer = gets.chomp.downcase

    output_save if answer.include?('y')
  end

  private

  def output_save
    saves = Dir.entries('Saves').reject { |element| element.length < 3 }
    puts 'which save file do you wish to load?'
    saves.each_with_index { |item, index| puts "#{index}; #{item}" }
    pick = gets.chomp.to_i

    load_game(saves[pick])
  end

end








