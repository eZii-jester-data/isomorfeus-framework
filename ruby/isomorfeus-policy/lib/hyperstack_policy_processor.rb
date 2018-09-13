class IsomorfeusPolicyProcessor
  def process_response(response)
    response.keys.each do |agent_object_id|
      agent = Isomorfeus::Transport::RequestAgent.get(agent_object_id)
      agent.result = response[agent_object_id]
    end
  end
end