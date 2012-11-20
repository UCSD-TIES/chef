
include_recipe "whwn"

supervisor_service "djcelery" do
  command "python app/manage.py celeryd -E -l info -c 2"
  directory node['whwn']['home']
  stderr_logfile "/var/log/supervisor/%(program_name)s_error.log"
  stdout_logfile "/var/log/supervisor/%(program_name)s.log"
  environment "PATH" => "#{node['whwn']['virtualenv']}/bin",
              "DJANGO_SETTINGS_MODULE" => "settings.development"
  action :enable
  autostart true
  user "whwn"
end

supervisor_service "celerycam" do
  command "python app/manage.py celerycam"
  directory node['whwn']['home']
  stderr_logfile "/var/log/supervisor/%(program_name)s_error.log"
  stdout_logfile "/var/log/supervisor/%(program_name)s.log"
  environment "PATH" => "#{node['whwn']['virtualenv']}/bin",
              "DJANGO_SETTINGS_MODULE" => "settings.development"
  action :enable
  autostart true
  user "whwn"
end