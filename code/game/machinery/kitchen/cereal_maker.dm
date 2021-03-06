/obj/machinery/cerealmaker
	name = "cereal maker"
	desc = "Now with Dann O's available!"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "cereal_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it making cereal already?

/obj/machinery/cerealmaker/attackby(obj/item/I, mob/user)
	if(on)
		user << "<span class='notice'>[src] is already processing, please wait.</span>"
		return
	if(istype(I, /obj/item/weapon/grab)||istype(I, /obj/item/tk_grab))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass/))
		user << "<span class='warning'>That would probably break [src].</span>"
		return
	if(!user.unEquip(I))
		user << "<span class='warning'>You cannot make cereal out of [I].</span>"
		return
	else
		user << "<span class='notice'>You put [I] into [src].</span>"
		on = TRUE
		user.drop_item()
		I.loc = src
		icon_state = "cereal_on"
		sleep(200)
		icon_state = "cereal_off"
		var/obj/item/weapon/reagent_containers/food/snacks/cereal/S = new(get_turf(src))
		var/image/img = new(I.icon, I.icon_state)
		img.transform *= 0.7
		if(istype(I, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food = I
			food.reagents.trans_to(S, food.reagents.total_volume)
		S.overlays += img
		S.name = "box of [I] cereal"
		playsound(loc, 'sound/machines/ding.ogg', 50, 1)
		on = FALSE
		qdel(I)

