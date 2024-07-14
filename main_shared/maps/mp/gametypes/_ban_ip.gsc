/*
     _    _    _                   _           _    
  /\| |/\| |  | |                 | |       /\| |/\ 
  \ ` ' /| |__| |_      _____  ___| |_ __ _ \ ` ' / 
 |_     _|  __  \ \ /\ / / _ \/ __| __/ _` |_     _|
  / , . \| |  | |\ V  V /  __/\__ \ || (_| |/ , . \ 
  \/|_|\/|_|  |_| \_/\_/ \___||___/\__\__,_|\/|_|\/ 
                                                    
                                                    

Shity ip-ban script by *hwesta*
used plugin for getip function: https://github.com/VikingKampfsau/cod4x_chatbot_admintool/tree/c065785e61e260e4cb1e5e5ec7bf8858220996e9/cod4x-server/plugins
banned ips stored in ip-banned directory
you can use banip and unbanip cmds 

*/

init()
{
	    //not sure what's this but isn't it better to set this in callbacksetup script?! God knows!
	    //level.onScriptCommand = ::Callback_ScriptCommand;
	    
    	addscriptcommand( "banip", 1 );
    	addscriptcommand( "unbanip", 1 );
    	
    	//make sure to set the permissions for cmds
    	//exec("AdminchangeCommandpower banip 30");
    	//exec("AdminchangeCommandpower unbanip 30");

	while(1)
	{
		level waittill( "connected", player );
		wait .1;
		if( isDefined( Player ) ) player thread ipCheck();
	}
}

ipCheck()
{
	self endon("disconnect");
    ip = self getplayerip();
    
    //exploit protection
    if( !isDefined( ip ) ) {
	exec("banclient " + self getEntityNumber() + " You have raised unspecified violations(4).. For the server security you are not allowed to play!");
	return;
    }

    block  = strTok( ip, ":" );
    ranges = strTok( block[0], "." );
    
    if( rangecheck( ranges ) ) {
    	exec("banclient " + self getEntityNumber() + " You have raised unspecified violations(4). For the server security you are not allowed to play.!");
    	return;
	}
    
	fileLoc = "IP-banned/" + "/" + block[0] + ".ipv4";
    if( FS_TestFile(fileLoc) )
	exec("banclient " + self getEntityNumber() + " You have raised unspecified violations(4). For the server security you are not allowed to play.!");
		
	
	return;
                
}

rangecheck( rangeblocks )
{
	self endon("disconnect");
	
	//1.2.3.0
	fileLoc = "IP-banned/" + "/" + rangeblocks[0] + "." + rangeblocks[1] + "." + rangeblocks[2] + ".0" + ".ipv4";
    if( FS_TestFile(fileLoc) ) return true;
    
    //1.2.0.0
    fileLoc = "IP-banned/" + "/" + rangeblocks[0] + "." + rangeblocks[1] + ".0.0" + ".ipv4";
    if( FS_TestFile(fileLoc) ) return true;
    
    //1.0.0.0 useless shit
    fileLoc = "IP-banned/" + "/" + rangeblocks[0] + ".0.0.0" + ".ipv4";
    if( FS_TestFile(fileLoc) ) return true;
	    
    return false;
	
}

Callback_ScriptCommand( command, arguments ){

    waittillframeend;
	cmd = toLower( command );

    if(!isDefined(self.name)){
		adminCommands( cmd, arguments );
	}
}

adminCommands( cmd, arg )
{
 if( !isDefined( cmd ) ) return;
 switch( toLower( cmd ) )
	{
		case "banip":
		
		if( !isDefined( arg ) || arg == "" ) if(isDefined(self.name)) {self iPrintlnbold("^1There is an error in processing command."); break;} else break;
        
        
        range = strTok( arg, "." );
        ap = 0;
        
        for(i = 0; i < 4; i++) if( !isDefined( range[i] ) ){
        if(isDefined(self.name)) {self iPrintlnbold("^1There is an error in processing command."); ap = 1; break;} else { ap = 1; break; }
		}
		if( ap ) break;
        
		fileLoc = "IP-banned/" + "/" + range[0] + "." + range[1] + "." + range[2] + "." + range[3] + ".ipv4";
		if( FS_TestFile(fileLoc) )
		{
		if(isDefined(self.name)) self iPrintlnbold("^1Already Added!");
		break;
	    }
	    
	    fpath = FS_FOpen(fileLoc, "write");
	    FS_FClose(fpath);
	    if(isDefined(self.name)) self iPrintlnbold("^1IP: ^3" + arg + " ^1Added To The Ban List.");
	    
	    //needs a ingame ip checking then banning
		break;
		
		case "unbanip":
		
		if( !isDefined( arg ) || arg == "" ) if(isDefined(self.name)) {self iPrintlnbold("^1There is an error in processing command."); break;} else break;

		fileLoc = "IP-banned/" + "/" + arg + ".ipv4";
		if( FS_TestFile(fileLoc) )
		{
	    FS_remove(fileloc);
	    if(isDefined(self.name)) self iPrintlnbold("^1IP: ^3" + arg + " ^1Removed From The Ban List.");
		break;
	    }
	    
		if(isDefined(self.name)) self iPrintlnbold("^1There Is No Such IP In The Ban List.");
		break; 
		
        default:break;
 
    }
}
