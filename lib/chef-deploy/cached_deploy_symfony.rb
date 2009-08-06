require 'cached_deploy'

class ChefDeploySymfonyFailure < ChefDeployFailure
end

class CachedDeploySymfony < CachedDeploy
  # Executes the SCM command for this strategy and writes the REVISION
  # mark file to each host.
  def deploy
    @configuration[:release_path] = "#{@configuration[:deploy_to]}/releases/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    if @configuration[:revision] == ''
       @configuration[:revision] = source.query_revision(@configuration[:branch]) {|cmd| run_with_result "#{cmd}"}
    end
    
    Chef::Log.info "ensuring proper ownership"
    chef_run("chown -R #{user}:#{group} #{@configuration[:deploy_to]}")    
    
    Chef::Log.info "deploying branch: #{@configuration[:branch]} rev: #{@configuration[:revision]}"
    Chef::Log.info "updating the cached checkout"
    chef_run(update_repository_cache)
    Chef::Log.info "copying the cached version to #{release_path}"
    chef_run(copy_repository_cache)
    install_gems
    
    chef_run("chown -R #{user}:#{group} #{@configuration[:deploy_to]}")    
    
    callback(:before_migrate)
    migrate
    callback(:before_symlink)
    symlink
    callback(:before_restart)
    restart
    callback(:after_restart)
    cleanup
  end
  
  def symlink(release_to_link=latest_release)
    Chef::Log.info "symlinking and finishing deploy"
    symlink = false
    begin
      chef_run [ "chmod -R g+w #{release_to_link}",
            "rm -rf #{release_to_link}/log #{release_to_link}/cache",
            "ln -nfs #{shared_path}/log #{release_to_link}/log",
            "ln -nfs #{shared_path}/cache #{release_to_link}/cache",
            "chown -R #{user}:#{group} #{release_to_link}"
          ].join(" && ")
      symlink = true
      chef_run "rm -f #{current_path} && ln -nfs #{release_to_link} #{current_path} && chown -R #{user}:#{group} #{current_path}"
    rescue => e
      chef_run "rm -f #{current_path} && ln -nfs #{previous_release(release_to_link)} #{current_path} && chown -R #{user}:#{group} #{current_path}" if symlink
      chef_run "rm -rf #{release_to_link}"
      raise e
    end
  end
  
end
