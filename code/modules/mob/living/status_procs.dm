/mob/living/proc/Stun(amount)
	if(status_flags & CANSTUN)
		stunned = max(max(stunned, amount), 0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		update_canmove()


/mob/living/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount, 0)
		update_canmove()


/mob/living/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		update_canmove()


/mob/living/proc/KnockDown(amount, force)
	if((status_flags & CANKNOCKDOWN) || force)
		knocked_down = max(max(knocked_down,amount),0)
		update_canmove()	//updates lying, canmove and icons


/mob/living/proc/SetKnockeddown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(amount,0)
		update_canmove()	//updates lying, canmove and icons


/mob/living/proc/AdjustKnockeddown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(knocked_down + amount,0)
		update_canmove()	//updates lying, canmove and icons


/mob/living/proc/KnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(max(knocked_out,amount),0)
		update_canmove()
	return

/mob/living/proc/SetKnockedout(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(amount,0)
		update_canmove()
	return

/mob/living/proc/AdjustKnockedout(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(knocked_out + amount,0)
		update_canmove()
	return

/mob/living/proc/Sleeping(amount)
	sleeping = max(max(sleeping,amount),0)
	return

/mob/living/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/living/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/living/proc/set_frozen(freeze = TRUE)
	frozen = freeze
	return TRUE

/mob/living/proc/adjust_drugginess(amount)
	return

/mob/living/proc/set_drugginess(amount)
	return

/mob/living/proc/Jitter(amount)
	jitteriness = CLAMP(jitteriness + amount,0, 1000)

/mob/living/proc/Dizzy(amount)
	return // For the time being, only carbons get dizzy.

/mob/living/proc/update_tint()
	return

/mob/living/proc/blind_eyes(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = max(eye_blind, amount)
		if(!old_eye_blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)

/mob/living/proc/adjust_blindness(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind += amount
		if(!old_eye_blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else if(eye_blind)
		var/blind_minimum = 0
		if(stat != CONSCIOUS)
			blind_minimum = 1
		if(isliving(src))
			var/mob/living/L = src
			if(!L.has_vision())
				blind_minimum = 1
		eye_blind = max(eye_blind+amount, blind_minimum)
		if(!eye_blind)
			clear_fullscreen("blind")

/mob/living/proc/set_blindness(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = amount
		if(client && !old_eye_blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else if(!eye_blind)
		var/blind_minimum = 0
		if(stat != CONSCIOUS)
			blind_minimum = 1
		if(isliving(src))
			var/mob/living/L = src
			if(!L.has_vision())
				blind_minimum = 1
		eye_blind = blind_minimum
		if(!eye_blind)
			clear_fullscreen("blind")

/mob/living/proc/blur_eyes(amount)
	if(amount>0)
		var/old_eye_blurry = eye_blurry
		eye_blurry = max(amount, eye_blurry)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)

/mob/living/proc/adjust_blurriness(amount)
	var/old_eye_blurry = eye_blurry
	eye_blurry = max(eye_blurry+amount, 0)
	if(amount>0)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
	else if(old_eye_blurry && !eye_blurry)
		clear_fullscreen("blurry")

/mob/living/proc/set_blurriness(amount)
	var/old_eye_blurry = eye_blurry
	eye_blurry = max(amount, 0)
	if(amount>0)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
	else if(old_eye_blurry)
		clear_fullscreen("blurry")

/mob/living/proc/adjustEarDamage(damage = 0, deaf = 0)
	ear_damage = max(0, ear_damage + damage)
	ear_deaf = max((sdisabilities & DEAF|| ear_damage >= 100) ? 1 : 0, ear_deaf + deaf)


/mob/living/proc/setEarDamage(damage, deaf)
	if(!isnull(damage))
		ear_damage = damage
	if(!isnull(deaf))
		ear_deaf = max((sdisabilities & DEAF|| ear_damage >= 100) ? 1 : 0, deaf)


/mob/living/adjust_drugginess(amount)
	druggy = max(druggy + amount, 0)
	if(druggy)
		overlay_fullscreen("high", /obj/screen/fullscreen/high)
	else
		clear_fullscreen("high")


/mob/living/set_drugginess(amount)
	druggy = max(amount, 0)
	if(druggy)
		overlay_fullscreen("high", /obj/screen/fullscreen/high)
	else
		clear_fullscreen("high")


/mob/living/proc/adjust_bodytemperature(amount,min_temp=0,max_temp=INFINITY)
	if(bodytemperature >= min_temp && bodytemperature <= max_temp)
		bodytemperature = CLAMP(bodytemperature + amount,min_temp,max_temp)