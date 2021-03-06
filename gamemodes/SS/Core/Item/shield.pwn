#include <YSI\y_hooks>


public OnPlayerUseItem(playerid, itemid)
{
	if(GetItemType(itemid) == item_Shield)
	{
		ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_IN", 5.0, 1, 0, 0, 0, 450);
		defer shield_Down(playerid, itemid);
		return 1;
	}
    #if defined shd_OnPlayerUseItem
		return shd_OnPlayerUseItem(playerid, itemid);
	#else
		return 0;
	#endif
}
#if defined _ALS_OnPlayerUseItem
    #undef OnPlayerUseItem
#else
    #define _ALS_OnPlayerUseItem
#endif
#define OnPlayerUseItem shd_OnPlayerUseItem
#if defined shd_OnPlayerUseItem
	forward shd_OnPlayerUseItem(playerid, itemid);
#endif

timer shield_Down[400](playerid, itemid)
{
	new
		Float:x,
		Float:y,
		Float:z,
		Float:angle;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	RemoveCurrentItem(playerid);
	SetItemPos(itemid, x + (0.5 * floatsin(-angle, degrees)), y + (0.5 * floatcos(-angle, degrees)), z - 0.2);
	SetItemRot(itemid, 90.0, 0.0, 180.0 + angle);
}

public OnPlayerShootPlayer(playerid, targetid, bodypart, Float:bleedrate, Float:knockmult, Float:bulletvelocity, Float:distance)
{
	if(_HandleShieldHit(playerid, targetid, bodypart))
		return 1;

	#if defined shd_OnPlayerShootPlayer
		return shd_OnPlayerShootPlayer(playerid, targetid, bodypart, bleedrate, knockmult, bulletvelocity, distance);
	#else
		return 0;
	#endif
}
#if defined _ALS_OnPlayerShootPlayer
	#undef OnPlayerShootPlayer
#else
	#define _ALS_OnPlayerShootPlayer
#endif
 
#define OnPlayerShootPlayer shd_OnPlayerShootPlayer
#if defined shd_OnPlayerShootPlayer
	forward shd_OnPlayerShootPlayer(playerid, targetid, bodypart, Float:bleedrate, Float:knockmult, Float:bulletvelocity, Float:distance);
#endif


_HandleShieldHit(playerid, targetid, bodypart)
{
	if(bodypart == 9)
		return 0;

	new ItemType:itemtype = GetItemType(GetPlayerItem(targetid));

	if(itemtype == item_Shield)
	{
		if((7 <= bodypart <= 8) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
			return 0;

		new
			Float:angleto,
			Float:targetangle;

		GetPlayerFacingAngle(targetid, targetangle);

		angleto = absoluteangle(targetangle - GetPlayerAngleToPlayer(targetid, playerid));

		if(45.0 < angleto < 135.0)
			return 1;
	}

	itemtype = GetItemType(GetPlayerHolsterItem(playerid));

	if(itemtype == item_Shield)
	{
		new
			Float:angleto,
			Float:targetangle;

		GetPlayerFacingAngle(targetid, targetangle);

		angleto = absoluteangle(targetangle - GetPlayerAngleToPlayer(targetid, playerid));

		if(155.0 < angleto < 205.0)
			return 1;
	}

	return 0;
}
