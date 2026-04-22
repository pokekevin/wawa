extends MarginContainer
#controls the doll submenu in the Cafe menu

func _ready():
	for i in range(Party.doll_list.size()):
		add_node(Party.doll_list[i])

var current_doll

func add_node(doll):
	var node = doll_list_button.new()
	node.text = doll["doll_base"].name
	node.set_name(doll["doll_base"].name)
	node.doll = doll
	node.doll_selected.connect(change_doll)
	var location = get_node("HBoxContainer/ScrollContainer/VBoxContainer")
	location.add_child(node)

func change_doll(doll):
	current_doll = doll
	var current_class = current_doll["class"]
	var skill_info
	
	#you could set text to something like this instead but it'll just print out a big blob with no adjustable ui so i didnt do it
	#for items in Party.kyuki:
		#x.text += (items, ": ", Party.kyuki[items])

	$HBoxContainer/Info/VBoxContainer/name.text = "Name: " + current_doll["doll_base"].name 
	$HBoxContainer/Info/VBoxContainer/trait.text = "Trait: " + str(current_doll["doll_base"].diTrait)
	$HBoxContainer/Info/VBoxContainer/trait_desc.text = str(current_doll["doll_base"].doll_trait_desc)
	
	$HBoxContainer/Info/VBoxContainer/dom.text = "Dominance: " + str(current_doll["dom"])
	$HBoxContainer/Info/VBoxContainer/inf.text = "Influence: " + str(current_doll["inf"])
	$HBoxContainer/Info/VBoxContainer/res.text = "Resolve: " + str(current_doll["res"])
	$HBoxContainer/Info/VBoxContainer/tem.text = "Tempo: " + str(current_doll["tem"])
	$HBoxContainer/Info/VBoxContainer/pre.text = "Precision: " + str(current_doll["pre"])
	$HBoxContainer/Info/VBoxContainer/affinity.text = "Affinity: " + str(current_doll["affinity"])
	
	
	$HBoxContainer/Info/VBoxContainer2/class_name.text = "Class: " + current_class.name
	$HBoxContainer/Info/VBoxContainer2/family.text = "Family: " + current_class.family
	$HBoxContainer/Info/VBoxContainer2/tier.text = "Tier: " + current_class.tier
	$HBoxContainer/Info/VBoxContainer2/trait.text = "Class Trait: " + current_class.dcTrait
	$HBoxContainer/Info/VBoxContainer2/trait_desc.text = "Class: " + current_class.class_trait_desc
	
	
	#xdd
	#needs to be its own popup eventually but w/e this works for now LMFAO
	var skill = current_class.skill1
	$HBoxContainer/Info/VBoxContainer2/skill1.text = "Skill 1: " +  " [hint=" + skill.dsName + "\n" + "Tier: " + skill.dsTier + "\n" + "AD: " + str(skill.dsAD) + "\n" + "Effect Description: " +  skill.skill_desc + "\n" + "Skill Type: " +  skill.dsType + "\n" + "Skill Target: " +  skill.dsTarget + "\n" + "ADM: " +  str(skill.dsADM) + "\n" + "Loss: " +  str(skill.dsLoss) + "\n" + "Cost: " +  str(skill.dsCost) + "\n" + "Crit Chance: " +  str(skill.dsCritChance) + "\n" + "Crit Multi: " +  str(skill.dsCritMulti) + "\n" + "Pen: " +  str(skill.dsPen) + "\n" + "Heal Multi: " +  str(skill.dsHealM) + "\n" + "Shield Multi: " +  str(skill.dsShieldM) + "\n" + "Ailment Type: " +  skill.dsAilmentType + "\n" + "Ailment Chance: " +  str(skill.dsAilmentChance) + "\n" + "Ailment Base Value: " +  str(skill.dsAilmentBase) + "\n" + "Ailment Multi: " +  str(skill.dsAilmentM) + "\n" + "Ailment More Chance: " +  str(skill.dsAilmentMore) + "]" + current_class.skill1.dsName + "[/hint]"
	
	skill = current_class.skill2
	$HBoxContainer/Info/VBoxContainer2/skill2.text = "Skill 2: " + " [hint=" + skill.dsName + "\n" + "Tier: " + skill.dsTier + "\n" + "AD: " + str(skill.dsAD) + "\n" + "Effect Description: " +  skill.skill_desc + "\n" + "Skill Type: " +  skill.dsType + "\n" + "Skill Target: " +  skill.dsTarget + "\n" + "ADM: " +  str(skill.dsADM) + "\n" + "Loss: " +  str(skill.dsLoss) + "\n" + "Cost: " +  str(skill.dsCost) + "\n" + "Crit Chance: " +  str(skill.dsCritChance) + "\n" + "Crit Multi: " +  str(skill.dsCritMulti) + "\n" + "Pen: " +  str(skill.dsPen) + "\n" + "Heal Multi: " +  str(skill.dsHealM) + "\n" + "Shield Multi: " +  str(skill.dsShieldM) + "\n" + "Ailment Type: " +  skill.dsAilmentType + "\n" + "Ailment Chance: " +  str(skill.dsAilmentChance) + "\n" + "Ailment Base Value: " +  str(skill.dsAilmentBase) + "\n" + "Ailment Multi: " +  str(skill.dsAilmentM) + "\n" + "Ailment More Chance: " +  str(skill.dsAilmentMore) + "]" + current_class.skill2.dsName + "[/hint]"
	
	skill = current_class.skill3
	$HBoxContainer/Info/VBoxContainer2/skill3.text = "Skill 3: " + " [hint=" + skill.dsName + "\n" + "Tier: " + skill.dsTier + "\n" + "AD: " + str(skill.dsAD) + "\n" + "Effect Description: " +  skill.skill_desc + "\n" + "Skill Type: " +  skill.dsType + "\n" + "Skill Target: " +  skill.dsTarget + "\n" + "ADM: " +  str(skill.dsADM) + "\n" + "Loss: " +  str(skill.dsLoss) + "\n" + "Cost: " +  str(skill.dsCost) + "\n" + "Crit Chance: " +  str(skill.dsCritChance) + "\n" + "Crit Multi: " +  str(skill.dsCritMulti) + "\n" + "Pen: " +  str(skill.dsPen) + "\n" + "Heal Multi: " +  str(skill.dsHealM) + "\n" + "Shield Multi: " +  str(skill.dsShieldM) + "\n" + "Ailment Type: " +  skill.dsAilmentType + "\n" + "Ailment Chance: " +  str(skill.dsAilmentChance) + "\n" + "Ailment Base Value: " +  str(skill.dsAilmentBase) + "\n" + "Ailment Multi: " +  str(skill.dsAilmentM) + "\n" + "Ailment More Chance: " +  str(skill.dsAilmentMore) + "]" + current_class.skill3.dsName + "[/hint]"
	
	skill = current_class.skill4
	$HBoxContainer/Info/VBoxContainer2/skill4.text = "Skill 4: " + " [hint=" + skill.dsName + "\n" + "Tier: " + skill.dsTier + "\n" + "AD: " + str(skill.dsAD) + "\n" + "Effect Description: " +  skill.skill_desc + "\n" + "Skill Type: " +  skill.dsType + "\n" + "Skill Target: " +  skill.dsTarget + "\n" + "ADM: " +  str(skill.dsADM) + "\n" + "Loss: " +  str(skill.dsLoss) + "\n" + "Cost: " +  str(skill.dsCost) + "\n" + "Crit Chance: " +  str(skill.dsCritChance) + "\n" + "Crit Multi: " +  str(skill.dsCritMulti) + "\n" + "Pen: " +  str(skill.dsPen) + "\n" + "Heal Multi: " +  str(skill.dsHealM) + "\n" + "Shield Multi: " +  str(skill.dsShieldM) + "\n" + "Ailment Type: " +  skill.dsAilmentType + "\n" + "Ailment Chance: " +  str(skill.dsAilmentChance) + "\n" + "Ailment Base Value: " +  str(skill.dsAilmentBase) + "\n" + "Ailment Multi: " +  str(skill.dsAilmentM) + "\n" + "Ailment More Chance: " +  str(skill.dsAilmentMore) + "]" + current_class.skill4.dsName + "[/hint]"
	
	
	#to add: stat modifier, class changer
