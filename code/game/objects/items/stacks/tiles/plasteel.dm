/obj/item/stack/tile/plasteel
	name = "floor tile"
	singular_name = "floor tile"
	desc = "Those could work as a pretty decent throwing weapon"
	icon_state = "tile"
	w_class = 3.0
	force = 6.0
	matter = list("metal" = 937.5)
	throwforce = 8.0
	throw_speed = 3
	throw_range = 6
	flags_atom = CONDUCT
	max_amount = 60

/obj/item/stack/tile/plasteel/New(var/loc, var/amount=null)
	..()
	src.pixel_x = rand(1, 14)
	src.pixel_y = rand(1, 14)
	return

/*
/obj/item/stack/tile/plasteel/attack_self(mob/user as mob)
	if (usr.stat)
		return
	var/T = user.loc
	if (!( istype(T, /turf) ))
		to_chat(user, "<span class='warning'>You must be on the ground!</span>")
		return
	if (!( istype(T, /turf/open/space) ))
		to_chat(user, "<span class='warning'>You cannot build on or repair this turf!</span>")
		return
	src.build(T)
	src.add_fingerprint(user)
	use(1)
	return
*/

/obj/item/stack/tile/plasteel/proc/build(turf/S as turf)
	if (istype(S,/turf/open/space))
		S.ChangeTurf(/turf/open/floor/plating/airless)
	else
		S.ChangeTurf(/turf/open/floor/plating)
//	var/turf/open/floor/W = S.ReplaceWithFloor()
//	W.make_plating()
	return
