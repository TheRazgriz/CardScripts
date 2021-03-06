--Avian Spell Strategy
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsRace(RACE_WARRIOR+RACE_WINGEDBEAST) and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterMaximumSideFunctionEx(s.filter),tp,LOCATION_MZONE,0,2,nil)
end
function s.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dg=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_ONFIELD,nil)
	if chkc then return chkc:IsOnField() and s.filter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return #dg>0 end
end
function s.tdfilter(c)
	return c:IsAbleToDeck() and c:IsRace(RACE_WARRIOR+RACE_WINGEDBEAST) and c:IsLevelBelow(8)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--requirement
	
	--effect
	local dg=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_ONFIELD,nil)
	if #dg>0 then
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.Destroy(sg,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0))
		then
			local tg=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		end
	end
end
