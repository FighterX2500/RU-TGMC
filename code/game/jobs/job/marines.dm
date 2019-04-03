/datum/job/marine
	department_flag = ROLEGROUP_MARINE_SQUAD_MARINES
	supervisors = "the acting squad leader"
	selection_color = "#ffeeee"
	total_positions = 8
	spawn_positions = 8
	skills_type = /datum/skills/pfc
	idtype = /obj/item/card/id/dogtag
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT


/datum/job/marine

/datum/job/marine/generate_entry_message(mob/living/carbon/human/H)
	if(H.assigned_squad)
		. = ..() + {"\nYou have been assigned to: <b><font size=3 color=[squad_colors[H.assigned_squad.color]]>[lowertext(H.assigned_squad.name)] squad</font></b>.
		[flags_startup_parameters & ROLE_ADD_TO_MODE ? " Make your way to the cafeteria for some post-cryosleep chow, and then get equipped in your squad's prep room." : ""]""}

/datum/job/marine/generate_entry_conditions(mob/living/carbon/human/H)
	. = ..()
	if(flags_startup_parameters & ROLE_ADD_TO_MODE)
		H.nutrition = rand(60,250) //Start hungry for the default marine.


/datum/job/marine/standard
	title = "Squad Marine"
	comm_title = "Mar"
	paygrade = "E2"
	flag = ROLE_MARINE_STANDARD
	department_flag = ROLEGROUP_MARINE_SQUAD_MARINES
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD

/datum/job/marine/standard/generate_entry_message()
	. = ..() + {"\nYou are a rank-and-file soldier of the USCM, and that is your strength.
What you lack alone, you gain standing shoulder to shoulder with the men and women of the corps. Ooh-rah!"}

/datum/job/marine/standard/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)


/datum/job/marine/engineer
	title = "Squad Engineer"
	comm_title = "Eng"
	paygrade = "E3"
	total_positions = 6
	spawn_positions = 6
	flag = ROLE_MARINE_ENGINEER
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	skills_type = /datum/skills/combat_engineer

/datum/job/marine/engineer/generate_entry_message()
	. = ..() + {"\nYou have the equipment and skill to build fortifications, reroute power lines, and bunker down.
Your squaddies will look to you when it comes to construction in the field of battle."}

/datum/job/marine/engineer/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/tech(H), WEAR_BACK)


/datum/job/marine/medic
	title = "Squad Medic"
	comm_title = "Med"
	paygrade = "E3"
	total_positions = 8
	spawn_positions = 8
	flag = ROLE_MARINE_MEDIC
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	skills_type = /datum/skills/combat_medic

/datum/job/marine/medic/generate_entry_message()
	. = ..() + {"\nYou must tend the wounds of your squad mates and make sure they are healthy and active.
You may not be a fully-fledged doctor, but you stand between life and death when it matters."}

/datum/job/marine/medic/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/medic(H), WEAR_BACK)


/datum/job/marine/smartgunner
	title = "Squad Smartgunner"
	comm_title = "Cpl"
	paygrade = "E4"
	flag = ROLE_MARINE_SMARTGUN
	total_positions = 4
	spawn_positions = 4
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	skills_type = /datum/skills/smartgunner

/datum/job/marine/smartgunner/generate_entry_message()
	. = ..() + {"\nYou are the smartgunner. Your job is to provide heavy weapons support."}

/datum/job/marine/smartgunner/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)


/datum/job/marine/specialist
	title = "Squad Specialist"
	comm_title = "Spc"
	paygrade = "E5"
	flag = ROLE_MARINE_SPECIALIST
	total_positions = 4
	spawn_positions = 4
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	skills_type = /datum/skills/specialist

/datum/job/marine/specialist/generate_entry_message()
	. = ..() + {"\nYou are the very rare and valuable weapon expert, trained to use special equipment.
You can serve a variety of roles, so choose carefully."}

/datum/job/marine/specialist/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/specrag(H), WEAR_HEAD)


/datum/job/marine/leader
	title = "Squad Leader"
	comm_title = "SL"
	paygrade = "E6"
	flag = ROLE_MARINE_LEADER
	total_positions = 2
	spawn_positions = 2
	supervisors = "the acting commander"
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	skills_type = /datum/skills/SL

/datum/job/marine/leader/generate_entry_message()
	. = ..() + {"\nYou are responsible for the men and women of your squad. Make sure they are on task, working together, and communicating.
You are also in charge of communicating with command and letting them know about the situation first hand. Keep out of harm's way."}

/datum/job/marine/leader/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)


//Armor Crewmen
/datum/job/marine/tank_crew
	title = "Armor Crewman"
	comm_title = "AC"
	paygrade = "E8"
	flag = ROLE_TANK_OFFICER
	total_positions = 2
	spawn_positions = 2
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_TANK)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_TANK)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	skills_type = /datum/skills/armor_crew
	idtype = /obj/item/card/id/dogtag
	equipment = TRUE

/datum/job/marine/tank_crew/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3P/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tanker(H), WEAR_R_HAND)

/datum/job/marine/tank_crew/generate_entry_message(mob/living/carbon/human/H)
	return {"Your job is to operate and maintain ship's armored vehicles.
Your authority is limited to your own vehicle, where you have authority over the enlisted personnel. However, you can be put in charge in marine squads by command's orders."}

/datum/job/marine/mech_pilot
	title = "Walker Pilot"
	comm_title = "WP"
	paygrade = "E8"
	flag = ROLE_MECH_OFFICER
	total_positions = 1
	spawn_positions = 1
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_WALKER)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_WALKER)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	skills_type = /datum/skills/walker_pilot
	idtype = /obj/item/card/id/dogtag
	equipment = TRUE

/datum/job/marine/mech_pilot/generate_equipment(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3P/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tanker(H), WEAR_R_HAND)

/datum/job/marine/mech_pilot/generate_entry_message(mob/living/carbon/human/H)
	return {"Your job is to operate and maintain combat walkers.
Walkers cannot survive for long without marines supporting them, but your heavy arsenal can provide fire support in places, where tanks can't fit. Cooperation with marines and watching your flanks are the keys to survival."}