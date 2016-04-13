infected = []

@having_ebola = 0.2
@having_ebola_not_showing = 0.01
@N = 10
@test_is_negative = 5/10.to_f

def Pr(e, options={})
  value = instance_variable_get(("@") + e.to_s)
  return 1 - value if options.fetch(:complement, nil)
  value
end

@E = 0.105
@ebola_no_symp = (Pr(:having_ebola_not_showing) * @test_is_negative) / 0.105
@no_one_having_ebola = (Pr(:E, { complement: true }) ** 10)

puts Pr(:no_one_having_ebola, complement: true)

#persons = 1000000
#(persons/2).times do |i|
#  if rand < @having_ebola
#    infected[i] = 1
#  else
#    infected[i] = 0
#  end
#end
#
#(persons/2).times do |i|
#  index = i+(persons/2)
#  if rand < @having_ebola_not_showing
#    infected[index] = 1
#  else
#    infected[index] = 0
#  end
#end
#puts infected_chance = infected.select{|i| i==1}.count.to_f / infected.length.to_f
#
#
