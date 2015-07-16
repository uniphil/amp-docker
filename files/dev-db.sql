UPDATE dg_site_domain
  SET site_domain='localhost';

UPDATE dg_user
  SET password='a9993e364706816aba3e25717850c26c9cd0d89d';  --abc

UPDATE amp_global_settings
  SET settingsvalue = 'false'
  WHERE settingsname = 'Secure Server';
