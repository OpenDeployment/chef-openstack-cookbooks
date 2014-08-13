
def keepalived_master(role, tag, chef_environment = nil)
  chef_environment = chef_environment || node.chef_environment
  master = search(:node, "run_list:role\\[#{role}\\] AND \
                  chef_environment:#{chef_environment} AND \
                  tags:#{tag}") || []
  if master.empty?
    nodes = search(:node, "run_list:role\\[#{role}\\] AND \
                   chef_environment:#{chef_environment}") || []
    nodes = nodes.sort_by { |node| node.name } unless nodes.empty?
    if node.name.eql?(nodes.first.name)
      node.tags << tag unless node.tags.include?(tag)
      node.save
    end
    return nodes.first
  else
    return master.first
  end
end
