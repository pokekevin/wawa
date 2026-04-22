class_name Battle 
extends Control
#general battle script that controls most of the calcs for dolls enemy and party
#i tried doing this in a node-based composition system too instead and instancing nodes for the indiviual dolls but doing changes is too hard
#because theres too much dogshit calcs you need especially with the effects
#something something working memory diff total node death

#if a stat ends in "final", it means it needs to reflect another change somewhere. always use 'final' suffix stats for the finished calcs
#make sure never to change a resource or else it will change the values on disk

#init of variables to recieve dicts from exepedition_party and expedition
#to have doll_battle class instances inserted
var doll1
var doll2
var doll3
var doll4
#doll array for Party-wide stuff
var dolls = [
	doll1,
	doll2,
	doll3,
	doll4
]

#big party dictionary. not a class for better acessibility
var party: Dictionary = {
	"pMEnergy": 0,
	"pMEnergyM": 0,
	"pMEnergyFinal": 0,
	
	"pCEnergy": 0,
	
	"pEnergyRecovery": 0,
	"pEnergyRecoveryM": 0,
	"pEnergyRecoveryFinal": 0,
	
	"pNoteM": 0,
	
	"pDomM": 0,
	"pInfM": 0,
	"pResM": 0,
	"pTemM": 0,
	"pPreM": 0,
	
	"pADM": 0,
	"pDefM": 0,
	"pCritChanceM": 0,
	"pCritMultiM": 0,
	
	"pAilmentChanceM": 0,
	"pAilmentM": 0,
	"pBuffM": 0,
	"pHealM": 0,
	"pShieldM": 0,
	
	"pFortuneM": 0,
	"pAffinityM": 0,
}

#big enemy dictionary. not a class for better acessibility
var enemy: Dictionary = {
	"enemy_base": {},
	"eHP": 1,
	"eMHP": 0,
	"eLoss": 0,
	"eSkillQueue": "none",
	"eDef": 0,
	"eGDR": 0,
	"ePDR": 0,
	"eMDR": 0,
	"eADR": 0,
	"eDamage": 0,
	
	"eMStagger": 0,
	"eCStagger": 0,
}

var init_status = false

func _on_expedition_confirm_party(party_array, enemy_to_assign):
	#assigns dolls to the doll_battle class and initializes stuff
	#most below magic number stuff is outlined in the stat formulas in the spreadsheet
	for i in range(4):
		dolls[i] = doll_battle.new().doll
		dolls[i]["doll_base"] = party_array[i]  #expedition_party.party_doll_list[i]
		dolls[i]["diDom"] = dolls[i]["doll_base"]["dom"]
		dolls[i]["diInf"] = dolls[i]["doll_base"]["inf"]
		dolls[i]["diRes"] = dolls[i]["doll_base"]["res"]
		dolls[i]["diTem"] = dolls[i]["doll_base"]["tem"]
		dolls[i]["diPre"] = dolls[i]["doll_base"]["pre"]
		dolls[i]["diDefM"] = dolls[i]["diRes"] * 0.01
		dolls[i]["diInf"] = dolls[i]["diHealM"] * 0.03
		dolls[i]["diInf"] = dolls[i]["diShieldM"] * 0.03
		dolls[i]["diInf"] = dolls[i]["diADM"] * 0.04
		party["pMEnergy"] = dolls[i]["diRes"] * 10.0
		party["pNoteM"] = dolls[i]["diTem"] * 0.01
		
	party["pEnergyRecovery"] = party["pMEnergy"] / 100.0
	
	#doll init from the expedition party to here
	doll1 = dolls[0]
	doll2 = dolls[1]
	doll3 = dolls[2]
	doll4 = dolls[3]
	dolls[0] = doll1
	dolls[1] = doll2
	dolls[2] = doll3
	dolls[3] = doll4
	
	#enemy init; temp
	enemy["enemy_base"] = enemy_to_assign
	
	enemy_skill_array = [enemy["enemy_base"].Skill1, enemy["enemy_base"].Skill2, enemy["enemy_base"].Skill3, enemy["enemy_base"].Skill4, enemy["enemy_base"].Skill5, enemy["enemy_base"].Skill6, enemy["enemy_base"].Skill7, enemy["enemy_base"].Skill8, enemy["enemy_base"].SkillUlt]
	enemy["eMHP"] = enemy["enemy_base"].MHP
	enemy["eDef"] = enemy["enemy_base"].Def
	enemy["eGDR"] = enemy["enemy_base"].GDR
	enemy["ePDR"] = enemy["enemy_base"].PDR
	enemy["eMDR"] = enemy["enemy_base"].MDR
	enemy["eAHP"] = enemy["enemy_base"].ADR
	enemy["eDamage"] = enemy["enemy_base"].Damage
	enemy["eMStagger"] = enemy["enemy_base"].MStagger
	enemy["eHP"] = enemy["eMHP"]
	
	move_select()
	init_status = true
	#hopefully temporary. needs 2 runs to initialize and then set the doll hp and i dont know how to fix it xdd
	stat_final()
	stat_final()
	for i in range(4):
		dolls[i]["diHP"] = dolls[i]["diMHPFinal"]

func _ready():
	get_parent().confirm_party.connect(_on_expedition_confirm_party)

var frame_count = 0
var note_count = 0
#timer for the baseline note counts
#60fps
func _physics_process(delta):
	frame_count += 1
	if init_status == false:
		return
	#bandage fix for updates without init crashing (idk if therse better way to fix me stupid)
	
	update_info()
	#visual ui updates
	
	skill_queue()
	#skill queue; NEEDS TO BE SOPHISTICATEIFIED LATER NEEDS A FIRST-COME-FIRST-SERVE PRIORITY SYSTEM
	
	maintenance_check()
	#updates health stats so that they don't go below 0 or above max
	
	stat_final()
	#updates stats that need to be modified
	
	if frame_count > 15:
		global_note_timer()
	if frame_count > (15 * (1 - (party["pNoteM"])) ):
		#for dolls. affected by haste
		note_timer()
	#updates note count
	
	enemy_behaviour()
	#runs enemy ai

func note_timer():
	energy_recovery()
	loss_recovery()

func global_note_timer():
	note_count += 1
	frame_count = 0
	enemy_loss_recovery()
	on_note_do()

#checks hp values
func maintenance_check():
	for i in range(4):
		if dolls[i]["diHP"] > dolls[i]["diMHPFinal"]:
			dolls[i]["diHP"] = dolls[i]["diMHPFinal"]
		if dolls[i]["diHP"] < 0:
			dolls[i]["diHP"] = 0
			#insert death mechanic here
	if enemy["eHP"] <= 0:
		battle_end()

signal battle_end_signal
var battle_ended = false #need this since it runs on game tick so it doesnt dupe
#battle end function
func battle_end():
	if battle_ended == false:
		emit_signal("battle_end_signal", "won")
		battle_ended = true

#converts necessary stats for damage calcs
func stat_final():
	for i in range(4):
		dolls[i]["diMHPFinal"] = (dolls[i]["diMHP"] + (dolls[i]["diResFinal"] * 10)) * (1 + dolls[i]["diMHPM"])
		dolls[i]["diDefFinal"] = dolls[i]["diDef"] * (1 + dolls[i]["diDefM"] + (0.01 * dolls[i]["diResFinal"]) + party["pDefM"])
		
		dolls[i]["diDomFinal"] = dolls[i]["diDom"] * (1 + dolls[i]["diDomM"] + party["pDomM"])
		dolls[i]["diInfFinal"] = dolls[i]["diInf"] * (1 + dolls[i]["diInfM"] + party["pInfM"])
		dolls[i]["diResFinal"] = dolls[i]["diRes"] * (1 + dolls[i]["diResM"] + party["pResM"])
		dolls[i]["diTemFinal"] = dolls[i]["diTem"] * (1 + dolls[i]["diTemM"] + party["pTemM"])
		dolls[i]["diPreFinal"] = dolls[i]["diPre"] * (1 + dolls[i]["diPreM"] + party["pPreM"])
		
		dolls[i]["diADFinal"] = dolls[i]["diAD"] * (1 + dolls[i]["diADM"] + party["pADM"])
		dolls[i]["diCritChanceFinal"] = (dolls[i]["diCritChance"] + (dolls[i]["diPreFinal"] * 0.005)) * (1 + dolls[i]["diCritChanceM"] + party["pCritChanceM"])
		dolls[i]["diCritMultiFinal"] = (dolls[i]["diCritMulti"] + (dolls[i]["diPreFinal"] * 0.01)) * (1 + dolls[i]["diCritMultiM"] + party["pCritMultiM"])
		
		party["pMEnergy"] = dolls[i]["diResFinal"] * 10.0
		party["pNoteM"] = dolls[i]["diTemFinal"] * 0.01
		
	party["pEnergyRecovery"] = party["pMEnergy"] / 100.0


#temporary
func update_info():
	if not "none" in doll1["diSkillQueue"]:
		$doll1/move_queued.text = str(doll1["diSkillQueue"].dsName)
	if  "none" in doll1["diSkillQueue"]:
		$doll1/move_queued.text = "none"
	$doll1/hp.text = str(doll1["diHP"]) + (" + ") + str(doll1["diShield"]) 
	$doll1/loss.text = str(doll1["diLoss"])
	if not "none" in doll2["diSkillQueue"]:
		$doll2/move_queued.text = str(doll2["diSkillQueue"].dsName)
	if  "none" in doll2["diSkillQueue"]:
		$doll2/move_queued.text = "none"
	$doll2/hp.text = str(doll2["diHP"]) + (" + ") + str(doll2["diShield"]) 
	$doll2/loss.text = str(doll2["diLoss"])
	if not "none" in doll3["diSkillQueue"]:
		$doll3/move_queued.text = str(doll3["diSkillQueue"].dsName)
	if  "none" in doll3["diSkillQueue"]:
		$doll3/move_queued.text = "none"
	$doll3/hp.text = str(doll3["diHP"]) + (" + ") + str(doll3["diShield"]) 
	$doll3/loss.text = str(doll3["diLoss"])
	if not "none" in doll4["diSkillQueue"]:
		$doll4/move_queued.text = str(doll4["diSkillQueue"].dsName)
	if  "none" in doll4["diSkillQueue"]:
		$doll4/move_queued.text = "none"
	$doll4/hp.text = str(doll4["diHP"]) + (" + ") + str(doll4["diShield"]) 
	$doll4/loss.text = str(doll4["diLoss"])
	
	
	if not "none" in enemy["eSkillQueue"]:
		$enemy/move_queued.text = str(enemy["eSkillQueue"].esName)
	if  "none" in enemy["eSkillQueue"]:
		$enemy/move_queued.text = "none"
	$enemy/hp.text = str(enemy["eHP"])
	$enemy/loss.text = str(enemy["eLoss"])
	
	$energy_display.text = str(party["pCEnergy"]) + " / " + str(party["pMEnergy"])

#array of things that need to happen every note. append with traits/skills/dots, etc.
var on_note_array_skill: Array
#each array position takes up 3 bytes storing dolldict, skill effect, and value
var on_note_array_dot: Array
#each array position takes up 3 bytes storing dot name, dot value, and dot count
func on_note_do():
	if on_note_array_skill.is_empty() == false:
		for i in range(on_note_array_skill.size()):
			skill_effect(on_note_array_skill[i][0], on_note_array_skill[i][1], on_note_array_skill[i][2])
	if on_note_array_dot.is_empty() == false:
		for i in range(on_note_array_dot.size()):
			dot_ticker(on_note_array_dot[i][0], on_note_array_dot[i][1], on_note_array_dot[i][2])


func energy_recovery():
	if party["pCEnergy"] < party["pMEnergy"]:
		party["pCEnergy"] += (party["pEnergyRecovery"] * (1 + party["pEnergyRecoveryM"]))
	if party["pCEnergy"] > party["pMEnergy"]:
		party["pCEnergy"] = party["pMEnergy"]

func loss_recovery():
	for i in range(4):
		if dolls[i]["diLoss"] < 0:
			dolls[i]["diLoss"] = 0
		if dolls[i]["diLoss"] > 0:
			dolls[i]["diLoss"] -= 1

func dot_ticker(dot, value, count):
	match dot:
		"poison": enemy["eHP"] -= (value * count) - ((value * count) * (0.01*enemy["eGDR"])) #1hp per poison
		"scorch": enemy["eHP"] -= 0.001 * (value * count) - ((value * count) * (0.01*enemy["eGDR"])) #0.001% hp per scorch
		"bleed": enemy["eHP"] -= (value * count) - ((value * count) * (0.01*enemy["eGDR"])) #1hp per bleed

#loads in party members from the Expedition
func load_party_members(party_member_array):
	for i in range(4):
		dolls[i]["doll_base"] = party_member_array[i].duplicate(false)
		#this needs to be set to false for shallow copy; changed from godot 3

func skill_queue():
	var doll_loop
	if init_status == true:
		for i in range(4):
			doll_loop = dolls[i]
			if doll_loop["diLoss"] == 0 and not "none" in doll_loop["diSkillQueue"]:
				if party["pCEnergy"] > doll_loop["diSkillQueue"].dsCost:
					party["pCEnergy"] -= doll_loop["diSkillQueue"].dsLoss
					cast_skill(doll_loop, doll_loop["diSkillQueue"])



#////////////////////#
#enemy behaviour
#rn it's just on a loop system where it cycles through 8 skills
#i'll make a simple FSM later
#enemies should be MOSTLY predictable or else it's too much friction since it's fast APM game
var skill_count = 0
var stagger_state = false
var stagger_counter = 10
var enemy_skill_array
#ultimate move should ALWAYS be on index 8
func enemy_behaviour():
	enemy["eSkillQueue"] = enemy_skill_array[skill_count]
	enemy_skill_queue()

func enemy_loss_recovery():
	if stagger_state == true:
		stagger_counter -= 1
		if stagger_counter <= 0:
			stagger_state == false
	if stagger_state == false:
		if enemy["eCStagger"] >= enemy["eMStagger"]:
			stagger_state = true
			return
		enemy["eLoss"] -= 1

#need this system for future reactive enemy skilling
func enemy_skill_queue():
	if init_status == true:
		if enemy["eLoss"] == 0 and not "none" in enemy["eSkillQueue"]:
			enemy_cast_skill()

func enemy_cast_skill():
	var skill = enemy["eSkillQueue"]
	var target
	enemy["eLoss"] += skill.esLoss
	if skill.esTargeting1 == true:
		target = doll1
		enemy_skill_target(target, skill)
	if skill.esTargeting2 == true:
		target = doll2
		enemy_skill_target(target, skill)
	if skill.esTargeting3 == true:
		target = doll3
		enemy_skill_target(target, skill)
	if skill.esTargeting4 == true:
		target = doll4
		enemy_skill_target(target, skill)
	skill_count += 1
	if skill_count > 8:
		skill_count = 0

func enemy_skill_target(target, skill):
	var damage = (skill.esDamage * (1 + enemy["eDamage"]))
	var defense = target["diDefFinal"] - skill.esPen
	if not "none" in skill.esEffect:
		skill_effect(target, skill.esEffect, skill.esEffectValue)
	target["diHP"] -= damage - (damage * (defense / (defense + (2.5 * damage))))

#////////////////////#




#casting skills. needs doll and skill slot input (from 0-3)
func cast_skill(doll, skill_slot: Resource):
	
	var skill = skill_slot
	var critRoll = "none"
	
	doll["diLoss"] += skill_slot.dsLoss
	
	if skill.effect1 != "none":
		skill_effect(doll, skill.effect1, skill.effect1value)
	if skill.effect2 != "none":
		skill_effect(doll, skill.effect2, skill.effect2value)
	if skill.effect3 != "none":
		skill_effect(doll, skill.effect3, skill.effect3value)
	if skill.effect4 != "none":
		skill_effect(doll, skill.effect4, skill.effect4value)
	#don't array this because effects need to apply in a certain way sometimes 
	
	var calcCrit = 1
	#crit rolling
	if skill.dsType != "heal" || "shield":
		critRoll = crit_calc((skill.dsCritChance + doll["diCritChanceFinal"]))
		match critRoll:
			"none": calcCrit = 1
			"gold": calcCrit = 1 + ((doll["diCritMulti"] + skill["dsCritMulti"]) * (1 + doll["diCritMultiFinal"]))
			"red": calcCrit = 1.25 + ((doll["diCritMulti"] + skill["dsCritMulti"]) * (1 + doll["diCritMultiFinal"]))
			"black": calcCrit = 1.25 + (((doll["diCritMulti"] + skill["dsCritMulti"]) * (1 + doll["diCritMultiFinal"]) * 2))
			"white": calcCrit = 1.5 + (((doll["diCritMulti"] + skill["dsCritMulti"]) * (1 + doll["diCritMultiFinal"]) * 2)) #this needs pen
			"silver": calcCrit = 1.5 + (((doll["diCritMulti"] + skill["dsCritMulti"]) * (1 + doll["diCritMultiFinal"]) * 2)) #this needs pen
	
	#healing and shielding
	if "party" in skill.dsTarget:
		match skill.dsType:
			"heal":
				for i in range(4):
					dolls[i]["diHP"] += ((skill.dsAD) + (doll["diAdFinal"] * skill.dsADM)) * (1 + skill.dsHealM + doll["diHealM"] + party["pHealM"]) * (1 + 0.03 * doll["diInfFinal"])
			"shield":
				for i in range(4):
					dolls[i]["diShield"] += ((skill.dsAD) * (1 + skill.dsShieldM)) * (1 + skill.dsShieldM + doll["diShieldM"] + party["pShieldM"]) * (1 + 0.03 * doll["diInfFinal"])
		doll["diSkillQueue"] = "none"
		return
	if "self" in skill.dsTarget:
		match skill.dsType:
			"heal":
					doll["diHP"] += ((skill.dsAD) + (doll["diAdFinal"] * skill.dsADM)) * (1 + skill.dsHealM + doll["diHealM"] + party["pHealM"]) * (1 + 0.03 * doll["diInfFinal"])
			"shield":
					doll["diShield"] += ((skill.dsAD) + (doll["diAdFinal"] * skill.dsADM)) * (1 + skill.dsShieldM + doll["diShieldM"] + party["pShieldM"]) * (1 + 0.03 * doll["diInfFinal"])
		doll["diSkillQueue"] = "none"
		return
	
	
	#ailment calcs
	if (skill.dsAilmentType != "none"):
		var dot_roll = int(round((randi() % 100) + (skill.dsAilmentChance * (1 + party["pAilmentChanceM"] + doll["diAilmentChanceM"]) )))
		var dot_more_roll = int(round((randi() % 100) + skill.dsAilmentMore + doll["diAilmentMore"]))
		
		var dot_more_count = dot_more_roll/100 - (dot_more_roll%100)/100
		var dot_count = (dot_roll/100 - (dot_roll%100)/100 ) * (1 + dot_more_count)
		
		if dot_count > 0:
			var dot_value = skill.dsAilmentBase * (1 + skill.dsAilmentM + doll["diAilmentM"] + party["pAilmentM"]) 
			dot_effect(skill.dsAilmentType, dot_value, dot_count)
	
	#fianl damage calc
	var calcFinal = (((doll["diAdFinal"] * skill.dsADM) + skill.dsAD) * (1 + party["pADM"]) * (1 + (doll["diInfFinal"] * 0.04)) * calcCrit) * (1 + ((doll["diDomFinal"]) * 0.02))
	enemy_take_damage(doll, skill, calcFinal)
	doll["diSkillQueue"] = "none"

#final damage calc
func enemy_take_damage(doll, skill, damage):
	var calcFinal = 0
	var effective_def = enemy["eDef"] - (enemy["eDef"] * skill.dsPen)
	calcFinal = damage - ((damage * effective_def) / (effective_def + (2.5 * damage)))
	match skill.dsType:
		"phys": calcFinal = calcFinal * (1 - enemy["ePDR"] + doll["diPhysPen"])
		"mag": calcFinal = calcFinal * (1 - enemy["eMDR"] + doll["diMagPen"])
	enemy["eHP"] = enemy["eHP"] -  (calcFinal * (1 - enemy["eGDR"]))

#modular-ish effect func but need to reference the spreadsheet or else get cancer xdd
#there is a cleaner way to do this with nodes and a pseudo interface with classes which also can get resources
#but editing is harder because we need like 15 billion fucking nodes and this is a semi-turnbased rpg so w/e
func skill_effect(doll, effect, value):
	#um kevin why is there a huge block of code- SHUT UPPPP SHUT THE FUCKKK UPPPPP AHUISDFIHUFDASHIUFASHUOI
	#rule of thumb: defensive values and values with a max count should be changed along with its M counterpart
	#offensive and 'applications' should just use the party multiplier in the formula
	#flat stats dont influence other stats until otherwise stated
	match effect:
		"none": return
		"dsdiMHP": 
			doll["diMHP"] = (doll["diMHP"]) + (value * (1 + doll["diBuffM"] + party["pBuffM"]))
		"dsdiMHPM": 
			doll["diMHPM"] += value
		"dsdiHP": doll["diHP"] += value
		"dsdiDef": doll["diDef"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiDefM": 
			doll["diDefM"] += value
		"dsdiLoss": doll["diLoss"] += value
		
		"dsdiDom": doll["diDom"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiDomM": 
			doll["dsdiDomM"] += value
		"dsdiInf": doll["diInf"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiInfM": 
			doll["diInfM"] += value
		"dsdiRes": 
			doll["diRes"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiResM": 
			doll["diResM"] += value
		"dsdiTem": doll["diTem"] += value  * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiTemM": 
			doll["diTemM"] += value
		"dsdiPre": doll["diPre"] += value  * (1 + doll["diBuffM"])
		"dsdiPreM": 
			doll["diPreM"] += value
		
		"dsdiAD": doll["diAD"] += value * (1 + doll["diBuffM"])
		"dsdiADM": doll["diADM"] += value
		"dsdiCritChance": doll["diCritChance"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiCritChanceM": doll["diCritChanceM"] += value
		"dsdiCritMulti": doll["diCritMulti"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiCritMultiMP": doll["diCritMultiM"] += value
		"dsdiAilmentChanceM": doll["diAilmentChanceM"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiAilmentM": doll["diAilmentM"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiAilmentMore": doll["diAilmentMore"] += value
		"dsdiBuffM": doll["diBuffM"] += value
		"dsdiHealM": doll["diHealM"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiShieldM": doll["diShieldM"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiPhysPen": doll["diPhysPen"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiMagPen": doll["diMagPen"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dsdiMore": doll["diMore"] += value
		
		
		"dspMEnergy": party["pMEnergy"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dspMEnergyM": 
			party["pMEnergyM"] += value
		"dspCEnergy": party["pCEnergy"] += value
		"dspEnergyRecovery": party["pEnergyRecovery"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dspEnergyRecoveryM": 
			party["pEnergyRecoveryM"] += value
		"dspNoteM": party["pNoteM"] += value
		"dspDomM": 
			party["pDomM"] += value
			dsp_stat_change("dsdiDomM", value)
		"dspInfM": 
			party["pInfM"] += value
			dsp_stat_change("dsdiInfM", value)
		"dspResM": 
			party["pResM"] += value
			dsp_stat_change("dsdiResM", value)
		"dspTemM": 
			party["pTemM"] += value
			dsp_stat_change("dsdiTemM", value)
		"dspPreM": 
			party["pPreM"] += value
			dsp_stat_change("dsdiPreM", value)
		"dspADM": party["pADM"] += value
		"dspDefM": 
			party["pDefM"] += value
			dsp_stat_change("dsdiDefM", value)
		"dspCritChanceM": party["pCritChanceM"] += value
		"dspCritMultiM": party["pCritMultiM"] += value
		"dspAilmentChanceM": party["pAilmentChanceM"] += value * (1 + doll["diBuffM"] + party["pBuffM"])
		"dspAilmentM": party["pAilmentM"] += value
		"dspBuffM": party["pBuffM"] += value
		"dspHealM": party["pHealM"] += value
		"dspShieldM": party["pShieldM"] += value

#use this function for any stat changes
func dsp_stat_change(stat, value):
	for i in range(4):
		skill_effect(dolls[i], stat, value)


#to be added later
func doll_trait_effect(doll):
	match doll:
		{"trait": "heroine"}: on_note_array_skill.append(["nigger", 1])

func class_trait_effect(doll):
	match doll:
		{"trait": "pacemaker"}: on_note_array_skill.append([doll, "dsdiTem", 1])



#calcs your crit chance and gives you back the corresponding crit bracket
func crit_calc(critchance):
	var crit_roll = randf_range(1, 101)
	var calcCrit = 0
	if (crit_roll + critchance) >= 100:
		calcCrit += 1
	
	match calcCrit:
		0: return "none"
		1: return "gold"
		2: return "red"
		3: return "black"
		4: return "white"
		5: return "silver"

#used for all ailments
func dot_effect(effect, value, stacks):
	value = value * (1 - enemy["eADR"])
	match effect:
		"shred": 
			enemy["ePDR"] -= enemy["ePDR"] * (0.01 * value * stacks)
			enemy["eMDR"] -= value * stacks
		"delay":
			enemy["eLoss"] += value * stacks
		"stun":
			enemy["eCStagger"] += value * stacks
		"weakness":
			enemy["eADR"] -= (0.01 * value * stacks)
		"poison": 
			on_note_array_dot.append(["poison", value, stacks])
		"scorch": on_note_array_dot.append(["scorch", value, stacks])
		"rime": enemy["eDamage"] -= (0.01 * value * stacks)
		"charge": enemy["eGDR"] -= (0.01 * value * stacks)
		"bleed": on_note_array_dot.append(["bleed", value, stacks])






#controls; temporary for testing and should be replaced by something more modular later
func pick_move(dollpos, slot):
	var dollname
	var dollskill
	match dollpos:
		1: dollname = doll1
		2: dollname = doll2
		3: dollname = doll3
		4: dollname = doll4
	match slot:
		1: dollskill = dollname["doll_base"]["class"].skill1
		2: dollskill = dollname["doll_base"]["class"].skill2
		3: dollskill = dollname["doll_base"]["class"].skill3
		4: dollskill = dollname["doll_base"]["class"].skill4
	
	cast_skill(dollname,dollskill)

var move_select_state = "party"
var selected_doll = 0
var selected_move = 0
var doll_to_show = doll1

func move_select():
	match move_select_state:
		"party":
			$moveselect/GridContainer/Button.text = doll1["doll_base"]["doll_base"]["name"]
			$moveselect/GridContainer/Button2.text = doll2["doll_base"]["doll_base"]["name"]
			$moveselect/GridContainer/Button3.text = doll3["doll_base"]["doll_base"]["name"]
			$moveselect/GridContainer/Button4.text = doll4["doll_base"]["doll_base"]["name"]
			move_select_state = "doll"
			selected_doll = 0
		"doll":
			match selected_doll:
				0: 
					pass
				1:
					doll_to_show = doll1
				2:
					doll_to_show = doll2
				3:
					doll_to_show = doll3
				4:
					doll_to_show = doll4
			$moveselect/GridContainer/Button.text = doll_to_show["doll_base"]["class"].skill1.dsName
			$moveselect/GridContainer/Button2.text = doll_to_show["doll_base"]["class"].skill2.dsName
			$moveselect/GridContainer/Button3.text = doll_to_show["doll_base"]["class"].skill3.dsName
			$moveselect/GridContainer/Button4.text = doll_to_show["doll_base"]["class"].skill4.dsName
			move_select_state = "skill"
			selected_move = 0
		"skill":
			var skill_to_cast
			match selected_move:
				1: skill_to_cast = doll_to_show["doll_base"]["class"].skill1
				2: skill_to_cast = doll_to_show["doll_base"]["class"].skill2
				3: skill_to_cast = doll_to_show["doll_base"]["class"].skill3
				4: skill_to_cast = doll_to_show["doll_base"]["class"].skill4
			doll_to_show["diSkillQueue"] = skill_to_cast
			move_select_state = "party"
			move_select()

func _input(event):
	if event.is_action_pressed("up"):
		selected_doll = 1
		selected_move = 1
		move_select()
	if event.is_action_pressed("left"):
		selected_doll = 2
		selected_move = 2
		move_select()
	if event.is_action_pressed("right"):
		selected_doll = 3
		selected_move = 3
		move_select()
	if event.is_action_pressed("down"):
		selected_doll = 4
		selected_move = 4
		move_select()
