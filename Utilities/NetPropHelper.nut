/*commands
!add [params]
!addall
!removeall
!remove [params]
!start
!end
*/

function InterceptChat(msg,speaker){
	if(msg.find("!start") != null){
		Start(speaker)
	} else if(msg.find("!end") != null){
		End()
	}
}

class Flag{
	constructor(name, type){
		flagname = name
		flagtype = type
	}
	
	function GetName(){
		return flagname
	}
	
	function SetValue(value){
		flagvalue = value
	}
	
	function GetValue(){
		return flagvalue
	}
	
	function GetType(){
		return flagtype
	}
	
	flagname = ""
	flagvalue = null
	flagtype = "integer"
}

local CPistol = [Flag("m_flSimulationTime","integer"), Flag("m_flCreateTime","float"), Flag("m_nModelIndex","integer"), Flag("m_hOwnerEntity","entity"), Flag("m_hEffectEntity","entity"), Flag("m_hScriptUseTarget","entity"), Flag("m_nSkin","integer"), Flag("m_nSequence","integer"), Flag("m_flPlaybackRate","float"), Flag("LocalWeaponData.m_iClip2","integer"), Flag("LocalWeaponData.m_iPrimaryAmmoType","integer"), Flag("LocalWeaponData.m_iSecondaryAmmoType","integer"), Flag("LocalWeaponData.m_nViewModelIndex","integer"), Flag("LocalActiveWeaponData.m_bOnlyPump","integer"), Flag("m_iState","integer"), Flag("m_iClip1","integer"), Flag("m_iExtraPrimaryAmmo","integer"), Flag("m_isDualWielding","integer"), Flag("m_hasDualWeapons","integer"), Flag("m_upgradeBitVec","integer"), Flag("m_reloadFromEmpty","integer"), Flag("m_inInitialPickup","integer"), Flag("m_partialReloadStage","integer")]
local CTerrorPlayer = [Flag("m_music.nv_m_zombatMusic3","float"),Flag("m_music.nv_m_CIDamageDuck","float"),Flag("m_music.nv_m_CIDamageMob","float"),Flag("m_music.nv_m_zombatMusic2","float"),Flag("m_music.nv_m_inCheckpoint","integer"),Flag("m_music.nv_m_ambientVolume","float"),Flag("m_music.nv_m_witchRage","float"),Flag("m_music.m_fNVAdrenaline", "float")]
local CTank = [Flag("m_lookatPlayer","entity"),Flag("m_bashedStart","float"),Flag("m_frustration","integer"),Flag("m_isCalm","integer"),Flag("m_zombieState","integer"),Flag("m_hasVisibleThreats","integer")]

local entity = null

function Start(){
	local ent = null
	while((ent = Entities.FindByClassname(ent,"player")) != null){
		if(NetProps.GetPropInt(ent,"m_zombieClass") == 8){
			break
		}
	}
	printl("starting: " + ent)
	entity = ent
	foreach(flag in CTank){
		if(flag.GetType() == "integer"){
			flag.SetValue(NetProps.GetPropInt(ent, flag.GetName()))
		} else if(flag.GetType() == "float"){
			flag.SetValue(NetProps.GetPropFloat(ent, flag.GetName()))
		} else if(flag.GetType() == "entity"){
			flag.SetValue(NetProps.GetPropEntity(ent, flag.GetName()))
		}
	}
}

function End(){
	printl("ending")
	foreach(flag in CTank){
		if(flag.GetType() == "integer"){
			if(NetProps.GetPropInt(entity, flag.GetName()) != flag.GetValue()){
				printl(flag.GetName() + ": " + NetProps.GetPropInt(entity, flag.GetName()) + " (was " + flag.GetValue() + ")")
			}
		} else if(flag.GetType() == "float"){
			if(NetProps.GetPropFloat(entity, flag.GetName()) != flag.GetValue()){
				printl(flag.GetName() + ": " + NetProps.GetPropFloat(entity, flag.GetName()) + " (was " + flag.GetValue() + ")")
			}
		} else if(flag.GetType() == "entity"){
			if(NetProps.GetPropEntity(entity, flag.GetName()) != flag.GetValue()){
				printl(flag.GetName() + ": " + NetProps.GetPropEntity(entity, flag.GetName()) + " (was " + flag.GetValue() + ")")
			}
		}
	}
}