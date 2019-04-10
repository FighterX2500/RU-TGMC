/client/proc/cmd_admin_select_mob_rank(var/mob/living/carbon/human/H in mob_list)
	set category = null
	set name = "Select Rank"

	if(!istype(H))
		return

	var/rank_list = list("Custom") + RoleAuthority.roles_by_name

	var/newrank = input("Select new rank for [H]", "Change the mob's rank and skills") as null|anything in rank_list

	if(!newrank)
		return

	if(!H?.mind)
		return

	feedback_add_details("admin_verb","SMRK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(newrank != "Custom")
		H.set_everything(H, newrank)
	else
		var/newcommtitle = input("Write the custom title appearing on the comms themselves, for example: \[Command (Title)]", "Comms title") as null|text

		if(!newcommtitle)
			return
		if(!H?.mind)
			return

		H.mind.role_comm_title = newcommtitle
		var/obj/item/card/id/I = H.wear_id

		if(!istype(I) || I != H.wear_id)
			to_chat(usr, "The mob has no id card, unable to modify ID and chat title.")
		else
			var/newchattitle = input("Write the custom title appearing in all chats: Title Jane Doe says", "Chat title") as null|text

			if(!H || I != H.wear_id)
				return

			I.paygrade = newchattitle

			var/IDtitle = input("Write the custom title appearing on the ID itself: Jane Doe's ID Card (Title)", "ID title") as null|text

			if(!H || I != H.wear_id)
				return

			I.rank = IDtitle
			I.assignment = IDtitle
			I.name = "[I.registered_name]'s ID Card[IDtitle ? " ([I.assignment])" : ""]"

		if(!H.mind)
			to_chat(usr, "The mob has no mind, unable to modify skills.")

		else
			var/newskillset = input("Select a skillset", "Skill Set") as null|anything in RoleAuthority.roles_by_name

			if(!newskillset)
				return

			if(!H?.mind)
				return

			var/datum/job/J = RoleAuthority.roles_by_name[newskillset]
			H.mind.set_cm_skills(J.skills_type)


/client/proc/cmd_admin_dress(var/mob/living/carbon/human/M in mob_list)
	set category = null
	set name = "Select Equipment"

	if(!ishuman(M))
		return

	var/answer = alert(usr, "Do you want jeser's special sets? Otherwise you will continue with standard dresspacks.", , "Yes", "No")

	if(answer == "No")

		var/list/dresspacks = list("Strip") + RoleAuthority.roles_by_equipment
		var/list/paths = list("Strip") + RoleAuthority.roles_by_equipment_paths

		var/dresscode = input("Choose equipment for [M]", "Select Equipment") as null|anything in dresspacks

		if(!dresscode)
			return

		var/path = paths[dresspacks.Find(dresscode)]

		feedback_add_details("admin_verb","SEQ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		for(var/obj/item/I in M)
			if(istype(I, /obj/item/implant) || istype(I, /obj/item/card/id))
				continue
			qdel(I)

		var/datum/job/J = new path
		J.generate_equipment(M)
		M.regenerate_icons()

		log_admin("[key_name(usr)] changed the equipment of [key_name(M)] to [dresscode].")
		message_admins("<span class='notice'> [key_name_admin(usr)] changed the equipment of [key_name_admin(M)] to [dresscode].</span>", 1)
		return

	else
		var/list/dresspacks = list(
		"USCM Squad Private",
		"USCM Squad Engineer",
		"USCM Squad Medic",
		"USCM Squad Smartgunner",
		"USCM Squad Specialist",
		"USCM Squad Leader",
		"UPP Soldier (Engineer)",
		"UPP Soldier (Heavy with RPG)")

		var/dresscode = input("Select equipment for [M].\nChanging equipment of not manually spawned humans is not recommended, since squad and role systems don't adapt to changes of this command. Except for that part, changing equipment will work and, if human was assigned with a squad, they will receive the equipment of corresponding squad. To make marine without a squad, first, select non-\"USCM Squad...\" and then the desired marine kit.", "Robust quick dress shop") as null|anything in dresspacks
		feedback_add_details("admin_verb","SEQ")
		var/squad
		if(M.assigned_squad)
			if(M.assigned_squad.name == "Alpha")
				squad = 1
			else if(M.assigned_squad.name == "Bravo")
				squad = 2

		for (var/obj/item/I in M)
			if (istype(I, /obj/item/implant) || istype(I, /obj/item/card/id))
				continue
			qdel(I)
		M.arm_equipment(M, dresscode, squad)
		M.regenerate_icons()
		log_admin("[key_name(usr)] changed the equipment of [key_name(M)] to [dresscode].")
		message_admins("\blue [key_name_admin(usr)] changed the equipment of [key_name_admin(M)] to [dresscode].", 1)
		return

/mob/proc/arm_equipment(var/mob/living/carbon/human/M, var/dresscode, var/squad)
	switch(dresscode)

		if("USCM Squad Private")
			var/list/wep_kits = list("M41A MK2 Rifle", "M41A MK2 Scope", "M41A Rifle", "M37A2 Shotgun", "MK221 Tactical Shotgun", "M39 SMG", "M240A1 Flamer", "M41AE2 HPR", "M43 Sunfury Lasgun MK1")
			var/kit_choice = input("Select weapon for [M]", "Robust quick dress shop") as null|anything in wep_kits
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
			M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing, M)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(M), WEAR_EYES)

			var/list/armor = list("M3 Standard Armor", "M3 Heavy Build Armor", "M3 Light Build Armor", "M3 Padded Armor", "M3 Integrated Storage Armor", "M3 Edge Armor")
			var/armor_choice = input("Select armor for [M]", "Robust quick dress shop") as null|anything in armor
			switch(armor_choice)
				if("M3 Standard Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(M), WEAR_JACKET)
				if("M3 Heavy Build Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3HB(M), WEAR_JACKET)
				if("M3 Light Build Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3LB(M), WEAR_JACKET)
				if("M3 Padded Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3P(M), WEAR_JACKET)
				if("M3 Integrated Storage Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3IS(M), WEAR_JACKET)
				if("M3 Edge Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3E(M), WEAR_JACKET)
				else
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(M), WEAR_JACKET)

			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
			M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)

			var/obj/item/storage/backpack/marine/satchel/B = new /obj/item/storage/backpack/marine/satchel(M)
			B.contents += new /obj/item/storage/box/m94
			B.contents += new /obj/item/storage/box/m94
			B.contents += new /obj/item/storage/box/MRE
			M.equip_to_slot_or_del(B, WEAR_BACK)

			M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(M), WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(M), WEAR_FACE)

			switch(kit_choice)
				if("M41A MK2 Rifle")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var /obj/item/weapon/gun/rifle/m41a/M41 = new(M.loc)
					var/obj/item/attachable/reddot/RD = new(M41)
					RD.Attach(M41)
					var/obj/item/attachable/stock/rifle/ST = new(M41)
					ST.Attach(M41)
					M41.update_attachables()
					M.equip_to_slot_or_del(M41, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/full_rifle(M), WEAR_WAIST)
				if("M41A MK2 Scope")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var /obj/item/weapon/gun/rifle/m41a/stripped/M41 = new(M.loc)
					var/obj/item/attachable/scope/SC = new(M41)
					SC.Attach(M41)
					var/obj/item/attachable/stock/rifle/ST = new(M41)
					ST.Attach(M41)
					var/obj/item/attachable/verticalgrip/VG = new(M41)
					VG.Attach(M41)
					var/obj/item/attachable/extended_barrel/EB = new(M41)
					EB.Attach(M41)
					M41.update_attachables()
					M.equip_to_slot_or_del(M41, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/full_rifle(M), WEAR_WAIST)
				if("M41A Rifle")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var /obj/item/weapon/gun/rifle/m41aMK1/M41 = new(M.loc)
					var/obj/item/attachable/reddot/RD = new(M41)
					RD.Attach(M41)
					var/obj/item/attachable/attached_gun/shotgun/SH = new(M41)
					SH.Attach(M41)
					M41.update_attachables()
					M.equip_to_slot_or_del(M41, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/full_rifle_mk1(M), WEAR_WAIST)
					B.contents += new /obj/item/ammo_magazine/shotgun/buckshot
				if("M37A2 Shotgun")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var /obj/item/weapon/gun/shotgun/pump/PMP = new(M.loc)
					var/obj/item/attachable/flashlight/FL = new(PMP)
					FL.Attach(PMP)
					var/obj/item/attachable/angledgrip/AG = new(PMP)
					AG.Attach(PMP)
					PMP.update_attachables()
					M.equip_to_slot_or_del(PMP, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun(M), WEAR_WAIST)
					B.contents += new /obj/item/ammo_magazine/shotgun
					B.contents += new /obj/item/ammo_magazine/shotgun/buckshot
					B.contents += new /obj/item/ammo_magazine/shotgun/flechette
				if("MK221 Tactical Shotgun")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var /obj/item/weapon/gun/shotgun/combat/CSH = new(M.loc)
					var/obj/item/attachable/flashlight/FL = new(CSH)
					FL.Attach(CSH)
					var/obj/item/attachable/stock/tactical/ST = new(CSH)
					ST.Attach(CSH)
					CSH.update_attachables()
					M.equip_to_slot_or_del(CSH, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun(M), WEAR_WAIST)
					B.contents += new /obj/item/ammo_magazine/shotgun
					B.contents += new /obj/item/ammo_magazine/shotgun/buckshot
					B.contents += new /obj/item/ammo_magazine/shotgun/flechette
				if("M39 SMG")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var/obj/item/weapon/gun/smg/m39/S = new(M.loc)
					var/obj/item/attachable/lasersight/LS = new(S)
					LS.Attach(S)
					var/obj/item/attachable/stock/smg/ST = new(S)
					ST.Attach(S)
					var/obj/item/attachable/reddot/RD = new(S)
					RD.Attach(S)
					var/obj/item/attachable/suppressor/SP = new(S)
					SP.Attach(S)
					S.update_attachables()
					M.equip_to_slot_or_del(S, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/full_smg(M), WEAR_WAIST)
				if("M240A1 Flamer")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/incendiary, M)
					M.wear_suit.attackby(new /obj/item/explosive/grenade/incendiary, M)
					var/obj/item/weapon/gun/flamer/FLM = new(M.loc)
					var/obj/item/attachable/flashlight/FL = new(FLM)
					FL.Attach(FLM)
					FLM.update_attachables()
					M.equip_to_slot_or_del(FLM, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(M), WEAR_WAIST)
					B.contents += new /obj/item/ammo_magazine/flamer_tank
					B.contents += new /obj/item/ammo_magazine/flamer_tank
					B.contents += new /obj/item/tool/extinguisher
				if("M41AE2 HPR")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var/obj/item/weapon/gun/rifle/lmg/L = new(M.loc)
					var/obj/item/attachable/reddot/RD = new(L)
					RD.Attach(L)
					var/obj/item/attachable/verticalgrip/VG = new(L)
					VG.Attach(L)
					var/obj/item/attachable/stock/rifle/ST = new(L)
					ST.Attach(L)
					L.update_attachables()
					M.equip_to_slot_or_del(L, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/full_lmg(M), WEAR_WAIST)
					M.wear_suit.attackby(new /obj/item/attachable/bipod, M)
				if("M43 Sunfury Lasgun MK1")
					M.wear_suit.attackby(new /obj/item/explosive/grenade/frag, M)
					var/obj/item/weapon/gun/energy/lasgun/M43/stripped/LG = new(M.loc)
					var/obj/item/attachable/reddot/RD = new(LG)
					RD.Attach(LG)
					var/obj/item/attachable/angledgrip/AG = new(LG)
					AG.Attach(LG)
					LG.update_attachables()
					M.equip_to_slot_or_del(LG, WEAR_J_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/full_lasgun(M), WEAR_WAIST)

			if(squad)
				switch(squad)
					if(1)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/alpha(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/alpha(M), WEAR_HANDS)
					if(2)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/bravo(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/bravo(M), WEAR_HANDS)
					if(3)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/charlie(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/charlie(M), WEAR_HANDS)
					if(4)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/delta(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/delta(M), WEAR_HANDS)
					else
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)
			else
				M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine(M), WEAR_EAR)
				M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)

		if("USCM Squad Engineer")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(M), WEAR_EYES)

			var/list/armor = list("M3 Standard Armor", "M3 Heavy Build Armor", "M3 Light Build Armor", "M3 Padded Armor", "M3 Integrated Storage Armor", "M3 Edge Armor")
			var/armor_choice = input("Select armor for [M]", "Robust quick dress shop") as null|anything in armor
			switch(armor_choice)
				if("M3 Standard Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(M), WEAR_JACKET)
				if("M3 Heavy Build Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3HB(M), WEAR_JACKET)
				if("M3 Light Build Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3LB(M), WEAR_JACKET)
				if("M3 Padded Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3P(M), WEAR_JACKET)
				if("M3 Integrated Storage Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3IS(M), WEAR_JACKET)
				if("M3 Edge Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3E(M), WEAR_JACKET)
				else
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(M), WEAR_JACKET)
			
			M.wear_suit.attackby(new /obj/item/explosive/plastique, M)
			M.wear_suit.attackby(new /obj/item/explosive/plastique, M)

			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing, M)
			M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
			M.head.attackby(new /obj/item/clothing/glasses/mgoggles, M)
			M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
			M.w_uniform.attackby(new /obj/item/device/assembly/signaler, M)
			M.w_uniform.attackby(new /obj/item/device/radio/detpack, M)
			M.w_uniform.attackby(new /obj/item/device/radio/detpack, M)

			var/obj/item/storage/backpack/marine/engineerpack/B = new /obj/item/storage/backpack/marine/engineerpack(M)
			B.contents += new /obj/item/tool/shovel/etool
			B.contents += new /obj/item/ammo_magazine/shotgun/buckshot
			B.contents += new /obj/item/device/lightreplacer
			B.contents += new /obj/item/storage/box/MRE

			M.equip_to_slot_or_del(B, WEAR_BACK)

			var/obj/item/weapon/gun/shotgun/pump/PMP = new(M.loc)
			var/obj/item/attachable/magnetic_harness/MH = new(PMP)
			MH.Attach(PMP)
			var/obj/item/attachable/angledgrip/AG = new(PMP)
			AG.Attach(PMP)
			PMP.update_attachables()
			M.equip_to_slot_or_del(PMP, WEAR_J_STORE)

			M.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics/full(M), WEAR_L_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_2(M), WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(M), WEAR_FACE)

			if(squad)
				switch(squad)
					if(1)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/alpha/engi(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/alpha/insulated(M), WEAR_HANDS)
					if(2)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/bravo/engi(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/bravo/insulated(M), WEAR_HANDS)
					if(3)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/charlie/engi(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/charlie/insulated(M), WEAR_HANDS)
					if(4)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/delta/engi(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/delta/insulated(M), WEAR_HANDS)
					else
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(M), WEAR_HANDS)
			else
				M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(M), WEAR_EAR)
				M.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(M), WEAR_HANDS)

		if("USCM Squad Medic")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(M), WEAR_EYES)

			var/list/armor = list("M3 Standard Armor", "M3 Heavy Build Armor", "M3 Light Build Armor", "M3 Padded Armor", "M3 Integrated Storage Armor", "M3 Edge Armor")
			var/armor_choice = input("Select armor for [M]", "Robust quick dress shop") as null|anything in armor
			switch(armor_choice)
				if("M3 Standard Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(M), WEAR_JACKET)
				if("M3 Heavy Build Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3HB(M), WEAR_JACKET)
				if("M3 Light Build Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3LB(M), WEAR_JACKET)
				if("M3 Padded Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3P(M), WEAR_JACKET)
				if("M3 Integrated Storage Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3IS(M), WEAR_JACKET)
				if("M3 Edge Armor")
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3E(M), WEAR_JACKET)
				else
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(M), WEAR_JACKET)
			
			M.wear_suit.attackby(new /obj/item/ammo_magazine/smg/m39/extended, M)
			M.wear_suit.attackby(new /obj/item/ammo_magazine/smg/m39/ap, M)

			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/combatLifesaver(M), WEAR_WAIST)
			M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
			M.head.attackby(new /obj/item/clothing/glasses/mgoggles, M)
			M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
			M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing, M)
			M.wear_suit.attackby(new /obj/item/ammo_magazine/smg/m39/extended, M)
			M.wear_suit.attackby(new /obj/item/ammo_magazine/smg/m39/ap, M)

			var/obj/item/storage/backpack/marine/medic/B = new /obj/item/storage/backpack/marine/medic(M)
			B.contents += new /obj/item/bodybag/cryobag
			B.contents += new /obj/item/device/defibrillator
			B.contents += new /obj/item/roller/medevac
			B.contents += new /obj/item/roller
			B.contents += new /obj/item/device/medevac_beacon
			B.contents += new /obj/item/reagent_container/hypospray/advanced/oxycodone
			B.contents += new /obj/item/storage/box/MRE
			M.equip_to_slot_or_del(B, WEAR_BACK)

			var/obj/item/weapon/gun/smg/m39/S = new(M.loc)
			var/obj/item/attachable/lasersight/LS = new(S)
			LS.Attach(S)
			var/obj/item/attachable/stock/smg/ST = new(S)
			ST.Attach(S)
			var/obj/item/attachable/magnetic_harness/MH = new(S)
			MH.Attach(S)
			S.update_attachables()
			M.equip_to_slot_or_del(S, WEAR_J_STORE)

			M.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full(M), WEAR_L_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(M), WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(M), WEAR_FACE)

			if(squad)
				switch(squad)
					if(1)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/alpha/med(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/alpha(M), WEAR_HANDS)
					if(2)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/bravo/med(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/bravo(M), WEAR_HANDS)
					if(3)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/charlie/med(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/charlie(M), WEAR_HANDS)
					if(4)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/delta/med(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/delta(M), WEAR_HANDS)
					else
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)
			else
				M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(M), WEAR_EAR)
				M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)

		if("USCM Squad Smartgunner")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
			M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
			M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing, M)

			var/obj/item/clothing/suit/storage/marine/smartgunner/J = new /obj/item/clothing/suit/storage/marine/smartgunner(M)
			J.pockets.contents += new /obj/item/storage/box/MRE
			M.equip_to_slot_or_del(J, WEAR_JACKET)

			M.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(M), WEAR_BACK)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(M), WEAR_EYES)

			var/obj/item/storage/large_holster/m39/BE = new /obj/item/storage/large_holster/m39(M)
			var/obj/item/weapon/gun/smg/m39/S = new(M.loc)
			var/obj/item/attachable/lasersight/LS = new(S)
			LS.Attach(S)
			var/obj/item/attachable/reddot/RD = new(S)
			RD.Attach(S)
			S.update_attachables()
			BE.contents += S
			BE.update_icon()
			M.equip_to_slot_or_del(BE, WEAR_WAIST)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(M), WEAR_J_STORE)

			M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
			var/obj/item/storage/pouch/magazine/RS = new /obj/item/storage/pouch/magazine(M)
			RS.contents += new /obj/item/ammo_magazine/smg/m39/extended
			RS.contents += new /obj/item/ammo_magazine/smg/m39/ap
			M.equip_to_slot_or_del(RS, WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(M), WEAR_FACE)

			if(squad)
				switch(squad)
					if(1)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/alpha(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/alpha(M), WEAR_HANDS)
					if(2)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/bravo(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/bravo(M), WEAR_HANDS)
					if(3)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/charlie(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/charlie(M), WEAR_HANDS)
					if(4)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/delta(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/delta(M), WEAR_HANDS)
					else
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)
			else
				M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine(M), WEAR_EAR)
				M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)

		if("USCM Squad Specialist")

			var/list/spec_kits = list("Stormtrooper", "Heavy Grenadier", "Pyrotechnician", "Scout", "Sniper", "Demolitionist")
			var/kit_choice = input("Select specialist kit for [M]", "Robust quick dress shop") as null|anything in spec_kits
			switch(kit_choice)
				if("Stormtrooper")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(M), WEAR_EYES)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/M40(M), WEAR_HEAD)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
					M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
					M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
					M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing, M)

					var/obj/item/clothing/suit/storage/marine/M40/J = new /obj/item/clothing/suit/storage/marine/M40(M)
					J.pockets.contents += new /obj/item/explosive/grenade/frag
					J.pockets.contents += new /obj/item/explosive/grenade/frag
					M.equip_to_slot_or_del(J, WEAR_JACKET)

					var/obj/item/storage/backpack/marine/satchel/B = new /obj/item/storage/backpack/marine/satchel(M)
					B.contents += new /obj/item/storage/box/MRE
					M.equip_to_slot_or_del(B, WEAR_BACK)

					var/obj/item/storage/belt/gun/m4a3/BE = new /obj/item/storage/belt/gun/m4a3(M)
					BE.contents += new /obj/item/ammo_magazine/pistol/vp70
					BE.contents += new /obj/item/ammo_magazine/pistol/vp70
					BE.contents += new /obj/item/ammo_magazine/pistol/vp70
					BE.contents += new /obj/item/ammo_magazine/pistol/vp70
		
					var/obj/item/weapon/gun/pistol/vp70/VP = new(M.loc)
					var/obj/item/attachable/lasersight/LS = new(VP)
					LS.Attach(VP)
					var/obj/item/attachable/reddot/RD = new(VP)
					RD.Attach(VP)
					VP.update_attachables()
					M.equip_to_slot_or_del(BE, WEAR_WAIST)
					M.belt.attackby(VP, M)

					M.equip_to_slot_or_del(new /obj/item/weapon/shield/montage(M), WEAR_L_HAND)

					M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
					var/obj/item/storage/pouch/magazine/large/RS = new /obj/item/storage/pouch/magazine/large(M)
					RS.contents += new /obj/item/ammo_magazine/pistol/vp70
					RS.contents += new /obj/item/ammo_magazine/pistol/vp70
					RS.contents += new /obj/item/ammo_magazine/pistol/vp70
					M.equip_to_slot_or_del(RS, WEAR_R_STORE)
	
				if("Heavy Grenadier")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(M), WEAR_EYES)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist(M), WEAR_HEAD)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/specialist(M), WEAR_HANDS)
					M.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/b18(M), WEAR_WAIST)
					M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
					M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
					M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing/, M)

					var/obj/item/clothing/suit/storage/marine/specialist/J = new /obj/item/clothing/suit/storage/marine/specialist(M)
					J.pockets.contents += new /obj/item/explosive/grenade/frag
					J.pockets.contents += new /obj/item/explosive/grenade/frag
					M.equip_to_slot_or_del(J, WEAR_JACKET)

					var/obj/item/storage/backpack/marine/satchel/B = new /obj/item/storage/backpack/marine/satchel(M)
					B.contents += new /obj/item/ammo_magazine/rifle
					B.contents += new /obj/item/ammo_magazine/rifle
					B.contents += new /obj/item/ammo_magazine/rifle
					B.contents += new /obj/item/storage/box/MRE
					M.equip_to_slot_or_del(B, WEAR_BACK)

					var/obj/item/weapon/gun/launcher/m92/GL = new(M.loc)
					var/obj/item/attachable/magnetic_harness/MH = new(GL)
					MH.Attach(GL)
					GL.update_attachables()
					M.equip_to_slot_or_del(GL, WEAR_J_STORE)

					var /obj/item/weapon/gun/rifle/m41a/stripped/M41 = new(M.loc)
					var/obj/item/attachable/reddot/RD = new(M41)
					RD.Attach(M41)
					var/obj/item/attachable/angledgrip/AG = new(M41)
					AG.Attach(M41)
					M41.update_attachables()
					M.equip_to_slot_or_del(M41, WEAR_R_HAND)

					M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
					var/obj/item/storage/pouch/magazine/large/RS = new /obj/item/storage/pouch/magazine/large(M)
					RS.contents += new /obj/item/ammo_magazine/rifle/extended
					RS.contents += new /obj/item/ammo_magazine/rifle/ap
					RS.contents += new /obj/item/ammo_magazine/rifle/ap
					M.equip_to_slot_or_del(RS, WEAR_R_STORE)

				if("Pyrotechnician")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(M), WEAR_EYES)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pyro(M), WEAR_HEAD)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
					M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
					M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
					M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing, M)

					var/obj/item/clothing/suit/storage/marine/M35/J = new /obj/item/clothing/suit/storage/marine/M35(M)
					J.pockets.contents += new /obj/item/explosive/grenade/incendiary
					J.pockets.contents += new /obj/item/explosive/grenade/incendiary
					M.equip_to_slot_or_del(J, WEAR_JACKET)

					var/obj/item/storage/backpack/marine/engineerpack/flamethrower/B = new /obj/item/storage/backpack/marine/engineerpack/flamethrower(M)
					B.contents += new /obj/item/ammo_magazine/flamer_tank/large
					B.contents += new /obj/item/ammo_magazine/flamer_tank/large
					B.contents += new /obj/item/ammo_magazine/flamer_tank/large/B
					B.contents += new /obj/item/ammo_magazine/flamer_tank/large/X
					B.contents += new /obj/item/storage/box/MRE
					M.equip_to_slot_or_del(B, WEAR_BACK)

					var/obj/item/storage/large_holster/m39/BE = new /obj/item/storage/large_holster/m39(M)
					var/obj/item/weapon/gun/smg/m39/S = new(M.loc)
					var/obj/item/attachable/lasersight/LS = new(S)
					LS.Attach(S)
					var/obj/item/attachable/reddot/RD = new(S)
					RD.Attach(S)
					S.update_attachables()
					BE.contents += S
					BE.update_icon()
					M.equip_to_slot_or_del(BE, WEAR_WAIST)

					var/obj/item/weapon/gun/flamer/M240T/FLM = new(M.loc)
					var/obj/item/attachable/magnetic_harness/MH = new(FLM)
					MH.Attach(FLM)
					FLM.update_attachables()
					M.equip_to_slot_or_del(FLM, WEAR_J_STORE)

					M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
					var/obj/item/storage/pouch/magazine/large/RS = new /obj/item/storage/pouch/magazine/large(M)
					RS.contents += new /obj/item/ammo_magazine/smg/m39/extended
					RS.contents += new /obj/item/ammo_magazine/smg/m39/ap
					RS.contents += new /obj/item/ammo_magazine/smg/m39
					M.equip_to_slot_or_del(RS, WEAR_R_STORE)

				if("Scout")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/M4RA(M), WEAR_EYES)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/scout(M), WEAR_HEAD)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
					M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
					M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
					M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing, M)
					M.w_uniform.attackby(new /obj/item/explosive/grenade/cloakbomb, M)
					M.w_uniform.attackby(new /obj/item/explosive/grenade/cloakbomb, M)
					M.w_uniform.attackby(new /obj/item/explosive/grenade/cloakbomb, M)

					var/obj/item/clothing/suit/storage/marine/M3S/J = new /obj/item/clothing/suit/storage/marine/M3S(M)
					J.pockets.contents += new /obj/item/device/binoculars/tactical/scout
					J.pockets.contents += new /obj/item/device/motiondetector/scout
					M.equip_to_slot_or_del(J, WEAR_JACKET)

					var/obj/item/weapon/gun/pistol/vp70/VP = new(M.loc)
					var/obj/item/attachable/suppressor/SP = new(VP)
					SP.Attach(VP)
					var/obj/item/attachable/reddot/RD = new(VP)
					RD.Attach(VP)
					VP.update_attachables()

					var/obj/item/storage/backpack/marine/satchel/scout_cloak/scout/B = new /obj/item/storage/backpack/marine/satchel/scout_cloak/scout(M)
					B.contents += new /obj/item/bodybag/tarp
					B.contents += VP
					B.contents += new /obj/item/ammo_magazine/pistol/vp70
					B.contents += new /obj/item/ammo_magazine/pistol/vp70
					B.contents += new /obj/item/storage/box/MRE
					M.equip_to_slot_or_del(B, WEAR_BACK)

					var/obj/item/storage/belt/marine/BE = new /obj/item/storage/belt/marine(M)
					BE.contents += new /obj/item/ammo_magazine/rifle/m4ra/incendiary
					BE.contents += new /obj/item/ammo_magazine/rifle/m4ra/incendiary
					BE.contents += new /obj/item/ammo_magazine/rifle/m4ra/impact
					BE.contents += new /obj/item/ammo_magazine/rifle/m4ra/impact
					BE.contents += new /obj/item/ammo_magazine/rifle/m4ra
					M.equip_to_slot_or_del(BE, WEAR_WAIST)

					var/obj/item/weapon/gun/rifle/m4ra/M41 = new(M.loc)
					var/obj/item/attachable/angledgrip/AG = new(M41)
					AG.Attach(M41)
					M41.update_attachables()
					M.equip_to_slot_or_del(M41, WEAR_J_STORE)

					M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
					var/obj/item/storage/pouch/magazine/large/RS = new /obj/item/storage/pouch/magazine/large(M)
					RS.contents += new /obj/item/ammo_magazine/rifle/m4ra
					RS.contents += new /obj/item/ammo_magazine/rifle/m4ra
					RS.contents += new /obj/item/ammo_magazine/rifle/m4ra
					M.equip_to_slot_or_del(RS, WEAR_R_STORE)

				if("Sniper")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles(M), WEAR_EYES)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(M), WEAR_HEAD)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
					M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
					M.head.attackby(new /obj/item/clothing/glasses/mgoggles, M)
					M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
					M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing/, M)
					M.w_uniform.attackby(new /obj/item/explosive/grenade/cloakbomb, M)
					M.w_uniform.attackby(new /obj/item/explosive/grenade/cloakbomb, M)
					M.w_uniform.attackby(new /obj/item/explosive/grenade/cloakbomb, M)

					var/obj/item/storage/large_holster/m39/BE = new /obj/item/storage/large_holster/m39(M)
					var/obj/item/weapon/gun/smg/m39/S = new(M.loc)
					var/obj/item/attachable/lasersight/LS = new(S)
					LS.Attach(S)
					var/obj/item/attachable/reddot/RD = new(S)
					RD.Attach(S)
					S.update_attachables()
					BE.contents += S
					BE.update_icon()
					M.equip_to_slot_or_del(BE, WEAR_WAIST)

					var/obj/item/clothing/suit/storage/marine/sniper/J = new /obj/item/clothing/suit/storage/marine/sniper(M)
					J.pockets.contents += new /obj/item/ammo_magazine/pistol/vp70
					J.pockets.contents += new /obj/item/ammo_magazine/pistol/vp70
					M.equip_to_slot_or_del(J, WEAR_JACKET)

					var/obj/item/weapon/gun/pistol/vp70/VP = new(M.loc)
					var/obj/item/attachable/suppressor/SP = new(VP)
					SP.Attach(VP)
					var/obj/item/attachable/reddot/RD2 = new(VP)
					RD2.Attach(VP)
					VP.update_attachables()

					var/obj/item/storage/backpack/marine/satchel/scout_cloak/sniper/B = new /obj/item/storage/backpack/marine/satchel/scout_cloak/sniper(M)
					B.contents += new /obj/item/bodybag/tarp
					B.contents += VP
					B.contents += new /obj/item/device/binoculars/tactical
					B.contents += new /obj/item/attachable/bipod
					B.contents += new /obj/item/facepaint/sniper
					B.contents += new /obj/item/ammo_magazine/sniper
					B.contents += new /obj/item/storage/box/MRE
					M.equip_to_slot_or_del(B, WEAR_BACK)

					M.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/M42A, WEAR_J_STORE)

					M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
					var/obj/item/storage/pouch/magazine/large/RS = new /obj/item/storage/pouch/magazine/large(M)
					RS.contents += new /obj/item/ammo_magazine/sniper
					RS.contents += new /obj/item/ammo_magazine/sniper/incendiary
					RS.contents += new /obj/item/ammo_magazine/sniper/flak
					M.equip_to_slot_or_del(RS, WEAR_R_STORE)
	
				if("Demolitionist")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(M), WEAR_EYES)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(M), WEAR_HEAD)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
					M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
					M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
					M.w_uniform.attackby(new /obj/item/clothing/tie/storage/webbing/, M)
					M.w_uniform.attackby(new /obj/item/device/assembly/signaler, M)
					M.w_uniform.attackby(new /obj/item/device/radio/detpack, M)
					M.w_uniform.attackby(new /obj/item/device/radio/detpack, M)

					var/obj/item/clothing/suit/storage/marine/M3T/J = new /obj/item/clothing/suit/storage/marine/M3T(M)
					J.pockets.contents += new /obj/item/ammo_magazine/smg/m39/extended
					J.pockets.contents += new /obj/item/ammo_magazine/smg/m39/ap
					M.equip_to_slot_or_del(J, WEAR_JACKET)

					var/obj/item/storage/large_holster/m39/BE = new /obj/item/storage/large_holster/m39(M)
					var/obj/item/weapon/gun/smg/m39/S = new(M.loc)
					var/obj/item/attachable/lasersight/LS = new(S)
					LS.Attach(S)
					var/obj/item/attachable/reddot/RD = new(S)
					RD.Attach(S)
					S.update_attachables()
					BE.contents += S
					BE.update_icon()
					M.equip_to_slot_or_del(BE, WEAR_WAIST)

					var/obj/item/storage/backpack/marine/satchel/B = new /obj/item/storage/backpack/marine/satchel(M)
					B.contents += new /obj/item/ammo_magazine/rocket/ap
					B.contents += new /obj/item/ammo_magazine/rocket
					B.contents += new /obj/item/explosive/plastique
					B.contents += new /obj/item/explosive/plastique
					B.contents += new /obj/item/explosive/mine
					B.contents += new /obj/item/explosive/mine
					B.contents += new /obj/item/storage/box/MRE
					M.equip_to_slot_or_del(B, WEAR_BACK)

					var/obj/item/weapon/gun/launcher/rocket/RPG = new(M.loc)
					var/obj/item/attachable/scope/mini/MSCP = new(RPG)
					MSCP.Attach(RPG)
					RPG.update_attachables()
					M.equip_to_slot_or_del(RPG, WEAR_J_STORE)

					M.equip_to_slot_or_del(new /obj/item/attachable/magnetic_harness(M), WEAR_L_HAND)

					M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
					M.equip_to_slot_or_del(new /obj/item/storage/pouch/rpg/full(M), WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(M), WEAR_FACE)

			if(squad)
				switch(squad)
					if(1)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/alpha(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/alpha(M), WEAR_HANDS)
					if(2)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/bravo(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/bravo(M), WEAR_HANDS)
					if(3)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/charlie(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/charlie(M), WEAR_HANDS)
					if(4)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/delta(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/delta(M), WEAR_HANDS)
					else
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)
			else
				M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine(M), WEAR_EAR)
				M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)

		if("USCM Squad Leader")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(M), WEAR_EYES)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/full_rifle(M), WEAR_WAIST)
			M.shoes.attackby(new /obj/item/weapon/combat_knife, M)
			M.head.attackby(new /obj/item/clothing/glasses/mgoggles, M)
			M.head.attackby(new /obj/item/reagent_container/food/snacks/protein_pack, M)
			M.w_uniform.attackby(new /obj/item/clothing/tie/storage/black_vest, M)
			M.w_uniform.attackby(new /obj/item/device/binoculars/tactical, M)
			M.w_uniform.attackby(new /obj/item/map/current_map, M)
			M.w_uniform.attackby(new /obj/item/device/squad_beacon/bomb, M)
			M.w_uniform.attackby(new /obj/item/device/squad_beacon, M)
			M.w_uniform.attackby(new /obj/item/device/squad_beacon, M)

			var/obj/item/clothing/suit/storage/marine/leader/J = new /obj/item/clothing/suit/storage/marine/leader(M)
			J.pockets.contents += new /obj/item/device/radio
			J.pockets.contents += new /obj/item/device/whistle
			M.equip_to_slot_or_del(J, WEAR_JACKET)

			var/obj/item/storage/backpack/marine/satchel/B = new /obj/item/storage/backpack/marine/satchel(M)
			B.contents += new /obj/item/ammo_magazine/flamer_tank
			B.contents += new /obj/item/ammo_magazine/flamer_tank
			B.contents += new /obj/item/device/motiondetector
			B.contents += new /obj/item/device/radio
			B.contents += new /obj/item/storage/box/MRE
			M.equip_to_slot_or_del(B, WEAR_BACK)

			var /obj/item/weapon/gun/rifle/m41a/stripped/M41 = new(M.loc)
			var/obj/item/attachable/scope/mini/MSCP = new(M41)
			MSCP.Attach(M41)
			var/obj/item/attachable/stock/rifle/ST = new(M41)
			ST.Attach(M41)
			var/obj/item/attachable/verticalgrip/VG = new(M41)
			VG.Attach(M41)
			M41.update_attachables()
			M.equip_to_slot_or_del(M41, WEAR_J_STORE)

			var/obj/item/weapon/gun/flamer/FLM = new(M.loc)
			var/obj/item/attachable/flashlight/FL = new(FLM)
			FL.Attach(FLM)
			FLM.update_attachables()
			M.equip_to_slot_or_del(FLM, WEAR_R_HAND)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/launcher/rocket/m52(M), WEAR_L_HAND)

			M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
			var/obj/item/storage/pouch/general/large/RS = new /obj/item/storage/pouch/general/large(M)
			RS.contents += new /obj/item/explosive/grenade/frag/m15
			RS.contents += new /obj/item/explosive/grenade/frag/m15
			RS.contents += new /obj/item/explosive/grenade/incendiary
			M.equip_to_slot_or_del(RS, WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(M), WEAR_FACE)
			
			if(squad)
				switch(squad)
					if(1)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/alpha/lead(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/alpha(M), WEAR_HANDS)
					if(2)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/bravo/lead(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/bravo(M), WEAR_HANDS)
					if(3)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/charlie/lead(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/charlie(M), WEAR_HANDS)
					if(4)
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/delta/lead(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/delta(M), WEAR_HANDS)
					else
						M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(M), WEAR_EAR)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)
			else
				M.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(M), WEAR_EAR)
				M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(M), WEAR_HANDS)
			
		if("UPP Soldier (Engineer)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(M), WEAR_EYES)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(M), WEAR_WAIST)
			
			var/obj/item/clothing/suit/storage/faction/UPP/J = new /obj/item/clothing/suit/storage/faction/UPP(M)
			J.pockets.contents += new /obj/item/explosive/plastique
			J.pockets.contents += new /obj/item/explosive/plastique
			M.equip_to_slot_or_del(J, WEAR_JACKET)

			var/obj/item/storage/backpack/marine/engineerpack/upp/B = new /obj/item/storage/backpack/marine/engineerpack/upp(M)
			B.contents += new /obj/item/tool/shovel/etool
			B.contents += new /obj/item/reagent_container/food/snacks/upp
			B.contents += new /obj/item/ammo_magazine/rifle/type71
			B.contents += new /obj/item/explosive/grenade/frag/upp
			M.equip_to_slot_or_del(B, WEAR_BACK)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71(M), WEAR_J_STORE)

			M.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp(M), WEAR_L_STORE)
			M.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_2(M), WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(M), WEAR_FACE)

		if("UPP Soldier (Heavy with RPG)")
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(M), WEAR_EAR)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(M), WEAR_BODY)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP/heavy(M), WEAR_HEAD)
			M.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full(M), WEAR_WAIST)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(M), WEAR_FEET)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(M), WEAR_HANDS)
			
			var/obj/item/clothing/suit/storage/faction/UPP/heavy/J = new /obj/item/clothing/suit/storage/faction/UPP/heavy(M)
			J.pockets.contents += new /obj/item/device/radio
			J.pockets.contents += new /obj/item/tool/crowbar/red
			M.equip_to_slot_or_del(J, WEAR_JACKET)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/launcher/rocket/m52/upp(M), WEAR_BACK)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71(M), WEAR_J_STORE)

			M.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(M), WEAR_L_STORE)
			var/obj/item/storage/pouch/general/large/RS = new /obj/item/storage/pouch/general/large(M)
			RS.contents += new /obj/item/explosive/plastique
			RS.contents += new /obj/item/explosive/grenade/frag/upp
			RS.contents += new /obj/item/reagent_container/food/snacks/upp
			M.equip_to_slot_or_del(RS, WEAR_R_STORE)

			if(map_tag == MAP_ICE_COLONY)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(M), WEAR_FACE)
