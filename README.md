# empty-password-reset

This plugin was developed to reset your servers password to a default password, everytime the servers goes empty.
This is very useful, if your server can be used by other people for scrims and matches, and they always forget to reset the password before leaving, making the server unavailable for the next players.

## Usage

Just copy **empty-password-reset.smx** to your **addons/sourcemod/plugins** folder.

Add the following commands to your **server.cfg**

```bash
sm_password_reset_enabled 1
sm_password_reset_default <your_servers_default_password>
```

## Credits

This plugin was created based on Alex Dragokas's empty server restarter
https://forums.alliedmods.net/showthread.php?p=2646309
