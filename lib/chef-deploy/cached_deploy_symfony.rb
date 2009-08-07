class ChefDeploySymfonyFailure < ChefDeployFailure
end

class CachedDeploySymfony < CachedDeploy

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
