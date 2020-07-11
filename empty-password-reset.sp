#define PLUGIN_VERSION "1.0"

#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#define CVAR_FLAGS			FCVAR_NOTIFY

// This plugin was created based on Alex Dragokas's empty server restarter
// https://forums.alliedmods.net/showthread.php?p=2646309
public Plugin myinfo = 
{
	name = "Empty Password Reset", 
	author = "Sonikro", 
	description = "Reset server password when everyone leaves",
	version = PLUGIN_VERSION, 
	url = "https://github.com/sonikro/empty-password-reset"
};


ConVar g_ConVarEnable;
ConVar g_ConVarDefaultPassword;

bool g_bCvarEnabled;
char g_sCvarDefaultPassword[64];
int g_fCvarDelay = 1;

public void OnPluginStart()
{
	g_ConVarEnable = CreateConVar("sm_password_reset_enabled", "1", "Enable plugin (1 - On / 0 - Off)", CVAR_FLAGS);
	g_ConVarDefaultPassword = CreateConVar("sm_password_reset_default", "mix", "The default password for your server", CVAR_FLAGS);
	
	GetCvars();
	
	g_ConVarEnable.AddChangeHook(OnCvarChanged);
	g_ConVarDefaultPassword.AddChangeHook(OnCvarChanged);
}

public void OnCvarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetCvars();
}

void GetCvars()
{
	g_bCvarEnabled = g_ConVarEnable.BoolValue;
	g_ConVarDefaultPassword.GetString(g_sCvarDefaultPassword, sizeof g_sCvarDefaultPassword);
	InitHook();
}

void InitHook()
{
	static bool bHooked;
	
	if( g_bCvarEnabled )
	{
		if( !bHooked )
		{
			HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);	
			bHooked = true;
		}
	} else {
		if( bHooked )
		{
			UnhookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);	
			bHooked = false;
		}
	}
}

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if( (client == 0 || !IsFakeClient(client)) && !RealPlayerExist(client) )
	{
		CreateTimer(g_fCvarDelay, Timer_CheckPlayers);
	}
	return Plugin_Continue;
}

public Action Timer_CheckPlayers(Handle timer, int UserId)
{
	if( !RealPlayerExist() )
	{
        ServerCommand("sv_password \"%s\"",g_sCvarDefaultPassword);
	}
}

bool RealPlayerExist(int iExclude = 0)
{
	for( int client = 1; client < MaxClients; client++ )
	{
		if( client != iExclude && IsClientConnected(client) )
		{
			if( !IsFakeClient(client) )
			{
				return true;
			}
		}
	}
	return false;
}