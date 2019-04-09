
var/list/upgrades = subtypesof(/datum/upgrade) //Removes the initial one
var/list/datum/upgrade/upgrade_list = list()

//Initializes upgrade datums. Always called at round start.
proc/initialize_upgrades()
	if(!upgrade_list.len)
		for(var/U in upgrades)
			upgrade_list += new U()

//The basic upgrade datums which hold pretty generic data.
/datum/upgrade
	var/name = "NOPE"
	var/cost = 0 //Cost in EP
	var/list/which_castes = list() //Which castes can buy this upgrade?
	var/is_global = 0
	var/is_verb = 0 //Is this a bonus verb that they get?
	var/procpath = null //Path to a proc, these will actually do all of the things.
	var/prev_required = null //Does this upgrade need a previous one bought to buy it?
	var/disable_prev_required = null
	var/u_tag = null //A u_tag string so we can grab it easily off a xeno. Must be unique.
	var/helptext = ""

/datum/upgrade/armor
	name = "Hardened Carapace"
	cost = 6
	which_castes = list(
						/mob/living/carbon/Xenomorph/Carrier,
						/mob/living/carbon/Xenomorph/Defiler,
						/mob/living/carbon/Xenomorph/Drone,
						/mob/living/carbon/Xenomorph/Hivelord,
						/mob/living/carbon/Xenomorph/Hunter,
						/mob/living/carbon/Xenomorph/Praetorian,
						/mob/living/carbon/Xenomorph/Ravager,
						/mob/living/carbon/Xenomorph/Runner,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Warrior,
						/mob/living/carbon/Xenomorph/Queen,
						/mob/living/carbon/Xenomorph/Boiler,
						/mob/living/carbon/Xenomorph/Crusher,
						/mob/living/carbon/Xenomorph/Drone
					)
	procpath = /mob/living/carbon/Xenomorph/proc/upgrade_armor
	u_tag = "cara"
	helptext = "Your exoskeleton becomes thicker, protecting you from projectiles."

/mob/living/carbon/Xenomorph/proc/upgrade_armor()
	if(src.xeno_caste.armor_deflection > 0)
		xeno_caste.armor_deflection += 15
		delta_armor += 15
	else
		xeno_caste.armor_deflection = 60
	to_chat(src, "<span class='xenonotice'>Your exoskeleton feels thicker.</span>")

/datum/upgrade/armor2
	name = "Blast Resistance"
	cost = 6
	which_castes = list(
						/mob/living/carbon/Xenomorph/Carrier,
						/mob/living/carbon/Xenomorph/Defiler,
						/mob/living/carbon/Xenomorph/Drone,
						/mob/living/carbon/Xenomorph/Hivelord,
						/mob/living/carbon/Xenomorph/Hunter,
						/mob/living/carbon/Xenomorph/Praetorian,
						/mob/living/carbon/Xenomorph/Ravager,
						/mob/living/carbon/Xenomorph/Runner,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Warrior,
						/mob/living/carbon/Xenomorph/Queen,
						/mob/living/carbon/Xenomorph/Boiler,
						/mob/living/carbon/Xenomorph/Crusher,
						/mob/living/carbon/Xenomorph/Drone
					)
	procpath = /mob/living/carbon/Xenomorph/proc/upgrade_bombs
	u_tag = "antibomb"
	helptext = "You grow a layer of insulation under your exoskeleton, protecting you from explosions."

/mob/living/carbon/Xenomorph/proc/upgrade_bombs()
	src.maxHealth = round(maxHealth * 8 / 7)
	delta_hp = delta_hp * 8/7
	to_chat(src, "<span class='xenonotice'>You grow a new layer on your exoskeleton.</span>")


/datum/upgrade/jelly
	name = "Quickened Evolution"
	cost = 6
	which_castes = list(
						/mob/living/carbon/Xenomorph/Drone,
						/mob/living/carbon/Xenomorph/Hunter,
						/mob/living/carbon/Xenomorph/Praetorian,
						/mob/living/carbon/Xenomorph/Runner,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Warrior,
						/mob/living/carbon/Xenomorph/Drone
					)
	procpath = /mob/living/carbon/Xenomorph/proc/upgrade_jelly
	u_tag = "jelly"
	helptext = "Quicken the speed at which royal jelly metabolizes, granting you new forms faster."

/mob/living/carbon/Xenomorph/proc/upgrade_jelly()
	if(hive_datum[hivenumber].living_xeno_queen.ovipositor)
		evolution_stored += 80
	else
		evolution_stored += 20
	to_chat(src, "<span class='xenonotice'>You feel royal jelly ripple through your haemolymph.</span>")

/datum/upgrade/jelly2
	name = "Quickened Upgrades"
	cost = 6
	which_castes = list(
						/mob/living/carbon/Xenomorph/Carrier,
						/mob/living/carbon/Xenomorph/Defiler,
						/mob/living/carbon/Xenomorph/Drone,
						/mob/living/carbon/Xenomorph/Hivelord,
						/mob/living/carbon/Xenomorph/Hunter,
						/mob/living/carbon/Xenomorph/Praetorian,
						/mob/living/carbon/Xenomorph/Ravager,
						/mob/living/carbon/Xenomorph/Runner,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Warrior,
						/mob/living/carbon/Xenomorph/Queen,
						/mob/living/carbon/Xenomorph/Boiler,
						/mob/living/carbon/Xenomorph/Crusher,
						/mob/living/carbon/Xenomorph/Drone,
					)
	procpath = /mob/living/carbon/Xenomorph/proc/upgrade_jelly2
	u_tag = "jelly2"
	helptext = "Quicken the speed at which royal jelly metabolizes, granting you new upgrades faster."

/mob/living/carbon/Xenomorph/proc/upgrade_jelly2()
	upgrade_stored += 100
	to_chat(src, "<span class='xenonotice'>You feel royal jelly ripple through your haemolymph.</span>")

/datum/upgrade/hive
	name = "Hive Upgrades HP"
	cost = 6
	which_castes = list(
						/mob/living/carbon/Xenomorph/Queen,
					)
	procpath = /mob/living/carbon/Xenomorph/proc/upgrade_hive
	u_tag = "hive_hp"
	helptext = "Upgrades stats HP of Hive."

/mob/living/carbon/Xenomorph/proc/upgrade_hive()
	for(var/mob/living/carbon/Xenomorph/X in living_mob_list)
		if(hivenumber && hivenumber <= hive_datum.len)
			X.maxHealth = round(X.maxHealth * 8 / 7)
	hive_datum[hivenumber].baff_hp = hive_datum[hivenumber].baff_hp * 8/7

/datum/upgrade/hive2
	name = "Hive Upgrades Armor"
	cost = 6
	which_castes = list(
						/mob/living/carbon/Xenomorph/Queen,
					)
	procpath = /mob/living/carbon/Xenomorph/proc/upgrade_hive2
	u_tag = "hive_armor"
	helptext = "Upgrades stats Armor of Hive."

/mob/living/carbon/Xenomorph/proc/upgrade_hive2()
	for(var/mob/living/carbon/Xenomorph/X in living_mob_list)
		if(hivenumber && hivenumber <= hive_datum.len)
			X.xeno_caste.armor_deflection += 15
	hive_datum[hivenumber].baff_armor += 15

//Changes a xeno's evolution points.
/mob/living/carbon/Xenomorph/proc/change_ep(var/amount)
	if(!src || !amount)
		return
	if(stat == DEAD)
		return //Dead xenos do not change at all.

	evo_points += amount
	if(evo_points < 0)
		evo_points = 0
	if(evo_points > 1000)
		evo_points = 1000

//Checks to see if they can spend some EP, and removes or adds it.
/mob/living/carbon/Xenomorph/proc/check_ep(var/amount)
	if(!src)
		return 0

	if(evo_points - amount < 0)
		to_chat(src, "<span class='warning'>You lack the required amount of evolution points - you need <B>[amount]</b> but have only <B>[evo_points]</b>.</span>")
		return 0
	return 1

/mob/living/carbon/Xenomorph/proc/has_upgrade(var/u_tag)
	if(!src || !u_tag)
		return 0

	if(u_tag in upgrades_bought)
		return 1

	return 0

proc/get_upgrade_by_u_tag(var/u_tag)
	for(var/datum/upgrade/U in upgrade_list)
		if(U.u_tag == u_tag)
			return U
	return null

//Also reduces evo points.
/mob/living/carbon/Xenomorph/proc/add_upgrade(var/datum/upgrade/U)
	if(!src)
		return 0
	if(stat == DEAD)
		return 0
	if(!U || !istype(U) || U.u_tag == null)
		return 0
	if(has_upgrade(U.u_tag))
		return 0 //They already have it.

	if(!check_ep(U.cost))
		return 0
	change_ep(U.cost * -1)
	upgrades_bought += U.u_tag
	call(src, U.procpath)()

/mob/living/carbon/Xenomorph/verb/Upgrades()
	set name = "Upgrades"
	set desc = "Time upgrades."
	set category = "Alien"
	var/upgrade_to_pick = list()
	var/text_helps = ""
	for(var/datum/upgrade/U in upgrade_list)
		if(xeno_caste.caste_type_path in U.which_castes)
			if(((U.prev_required in upgrades_bought) || !U.prev_required) && (!(U.disable_prev_required in upgrades_bought) || !U.disable_prev_required))
				if(!has_upgrade(U.u_tag))
					upgrade_to_pick += U.name
					text_helps += "[U.name]:<br>  [U.helptext]<br>"
	if(!text_helps)
		return
	upgrade_to_pick += "Help"
	var/upgradepick = input("You are growing into beautiful alien! Mommy will be proud!") as null|anything in upgrade_to_pick
	if(!upgradepick)
		return
	if(upgradepick == "Help")
		to_chat(src, "<span class='xenonotice'>[text_helps]</span>")
		return
	for(var/datum/upgrade/U in upgrade_list)
		if(U.name == upgradepick)
			add_upgrade(U)
			return
