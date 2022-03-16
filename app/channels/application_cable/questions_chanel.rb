class QuestionsChannel < ActionCable::Channel
  def echo(data)
    transmit data
  end
  
end