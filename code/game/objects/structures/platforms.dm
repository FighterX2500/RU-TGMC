/*
 * Platforms
 */
/obj/structure/platform
	name = "platform"
	desc = "Fortified platform."
	icon = 'icons/obj/structures/platforms.dmi'
	icon_state = "platform"
	climbable = TRUE
	anchored = TRUE
	density = 1
	throwpass = TRUE //You can throw objects over this, despite its density.
	layer = BELOW_OBJ_LAYER
	climb_delay = 30
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform/New()
	var/image/I = image(icon, src, "platform_overlay", LADDER_LAYER, dir)//ladder layer puts us just above weeds.
	switch(dir)
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
			I.pixel_y = -16
		if(NORTH)
			I.pixel_y = 16
		if(EAST)
			I.pixel_x = 16
		if(WEST)
			I.pixel_x = -16
	overlays += I
	..()

//this verb is made to update update levels of platforms, in case they were placed manually and rotated
/obj/structure/platform/proc/update_layer()
	switch(dir)
		if(SOUTH) layer = ABOVE_MOB_LAYER
		if(NORTH) layer = initial(layer) - 0.01
		else layer = initial(layer)
	
/obj/structure/platform/CheckExit(atom/movable/O, turf/target)
	if(O && O.throwing)
		return 1

	if(((flags_atom & ON_BORDER) && get_dir(loc, target) == dir))
		return 0
	else
		return 1

/obj/structure/platform/CanPass(atom/movable/mover, turf/target)
	if(mover && mover.throwing)
		return 1

	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return 1

	if(!(flags_atom & ON_BORDER) || get_dir(loc, target) == dir)
		return 0
	else
		return 1
/*
/obj/structure/platform/can_climb(var/mob/living/user)
	..()

	if(user.loc == loc)
		if(isXeno(user))
			var/turf/T = get_step(src, dir)
			for(var/obj/O in T.contents)
				if(istype(O, /obj/structure))
					var/obj/structure/S = O
					if(S.climbable)
						continue

				if(O.density && (!(O.flags_atom & ON_BORDER) || O.dir & getInvDir(dir)))
					to_chat(user, "<span class='warning'>There's \a [O.name] in the way.</span>")
					return FALSE
	
		else
			var/turf/T = get_step(src, dir)
			for(var/obj/O in T.contents)
				if(istype(O, /obj/structure))
					var/obj/structure/S = O
					if(S.climbable)
						if(!istype(S, /obj/structure/barricade))
							continue
			
				if(O.density && (!(O.flags_atom & ON_BORDER) || O.dir & getInvDir(dir)))
					to_chat(user, "<span class='warning'>There's \a [O.name] in the way.</span>")
					return FALSE
	
	return TRUE
*/
/obj/structure/platform/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	var/climb_delay_cur = climb_delay
	if(user.loc == get_step(get_turf(src), dir))
		user.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
		climb_delay_cur = 5
	else 
		if(user.loc == loc)
			user.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
			var/mob/living/carbon/human/O = user
			if(istype(O) && O.species && O.species.name == "Yautja")
				climb_delay_cur = 20
			if(isXeno(user))
				climb_delay_cur = 15
		else
			to_chat(user, "<span class='warning'>You need to be up against [src] to leap over.</span>")
			return

	if(!do_after(user, climb_delay_cur, FALSE, climb_delay_cur/5, BUSY_ICON_GENERIC))
		return

	if(!can_climb(user))
		return
	
	var/turf/target = get_step(get_turf(src), dir)
	if(user.loc == target)
		user.forceMove(get_turf(src))
		user.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")
	else
		if(target.density) //Turf is dense, not gonna work
			to_chat(user, "<span class='warning'>You cannot climb here.</span>")
			return
		for(var/atom/movable/A in target)
			if(A && A.density && !(A.flags_atom & ON_BORDER))
				if(istype(A, /obj/structure))
					var/obj/structure/S = A
					if(!S.climbable) //Transfer onto climbable surface
						to_chat(user, "<span class='warning'>You cannot climb here.</span>")
						return
				else
					to_chat(user, "<span class='warning'>You cannot climb here.</span>")
					return
		user.forceMove(get_turf(target)) //One more move, we "leap" over the border structure

		if(get_turf(user) == get_turf(target))
			user.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")

/obj/structure/platform/attackby(obj/item/W, mob/living/user)
	if(!ishuman(user) && !isXeno(usr))
		return // no

	if(!istype(W, /obj/item/grab))
		return
	
	var/obj/item/grab/G = W

	if(!can_climb(user))
		to_chat(user, "<span class='warning'>You also can't move [G.grabbed_thing] onto the [src].</span>")
		return
			
	visible_message("[user] starts moving [G.grabbed_thing] onto [src].", 3)

	var/move_time = 40
	if(isXeno(user) || user.loc == get_step(get_turf(src), dir))
		move_time = 20

	if(!do_after(user, move_time, FALSE, move_time/5, BUSY_ICON_GENERIC))
		to_chat(user, "<span class='warning'>You stopped moving [G.grabbed_thing] onto the [src]!</span>")
		return

	if(!can_climb(user))
		return
	
	var/turf/T
	if(user.loc == loc)
		T = get_step(get_turf(src), dir)
		if(get_turf(G.grabbed_thing) != T && get_turf(G.grabbed_thing) != get_step(T, turn(dir, -90)) && get_turf(G.grabbed_thing) != get_step(T, turn(dir, 90)))
			G.grabbed_thing.forceMove(T)
			visible_message("[user] moves [G.grabbed_thing] onto [src].", 3)
			to_chat(user, "<span class='notice'>You succesfully moved [G.grabbed_thing] onto [src]!</span>")
		else 
			G.grabbed_thing.forceMove(src.loc)
			visible_message("[user] moves [G.grabbed_thing] down from [src].", 3)
			to_chat(user, "<span class='notice'>You succesfully moved [G.grabbed_thing] down from [src]!</span>")
	else
		T = get_turf(src)
		if(get_turf(G.grabbed_thing) != T && get_turf(G.grabbed_thing) != get_step(T, turn(dir, -90)) && get_turf(G.grabbed_thing) != get_step(T, turn(dir, 90)))
			G.grabbed_thing.forceMove(T)
			visible_message("[user] moves [G.grabbed_thing] down from [src].", 3)
			to_chat(user, "<span class='notice'>You succesfully moved [G.grabbed_thing] down [src]!</span>")
		else 
			G.grabbed_thing.forceMove(get_turf(user))
			visible_message("[user] moves [G.grabbed_thing] onto [src].", 3)
			to_chat(user, "<span class='notice'>You succesfully moved [G.grabbed_thing] onto [src]!</span>")

	user.stop_pulling()
			
	return

obj/structure/platform_decoration
	name = "platform"
	desc = "Fortified platform."
	icon = 'icons/obj/structures/platforms.dmi'
	icon_state = "platform_deco"
	anchored = TRUE
	density = 0
	throwpass = TRUE
	layer = 3.5
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform_decoration/New()
	switch(dir)
		if (NORTH)
			layer = ABOVE_MOB_LAYER
		if (SOUTH)
			layer = ABOVE_MOB_LAYER
		if (SOUTHEAST)
			layer = ABOVE_MOB_LAYER
		if (SOUTHWEST)
			layer = ABOVE_MOB_LAYER
	.. ()