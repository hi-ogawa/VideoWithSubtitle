# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



rb_t = Title.find_or_create_by(:name => "the-mentalist")

rb_t_s_e = rb_t.numbers.find_or_create_by(:season  => 4,
                                          :episode => 10)

vocab_lists =
[[ "dissociative fugue" , "It's called dissociative fugue--  the temporary loss of personal identity." , "20150607_155439.png" ],
 [ "block out" , "His subconscious mind is protecting itself  from further trauma by blocking out that pain." , "20150607_155628.png" ],
 [ "widow" , "Satterfield left behind a widow, Diane." , "20150607_155952.png" ],
 [ "lucha" , "The lucha libre mask projects the correct attitude,  but look-- look what he is wearing--  khakis and a fitted sweater." , "20150607_160132.png" ],
 [ "khakis" , "The lucha libre mask projects the correct attitude,  but look-- look what he is wearing--  khakis and a fitted sweater." , "20150607_160155.png" ],
 [ "suss out" , "But you're still good at sussing out guilty parties." , "20150607_160425.png" ],
 [ "luscious" , "Well, in that case, Wayne,  what's the best way in with the luscious redhead?  Van Pelt?  Well, clearly you two had a thing, and she dumped you,  but maybe you can share a tip on how to open the cookie jar,  you know? Get some, uh  tasty gingersnaps?  Oh." , "20150607_160507.png" ],
 [ "highest regard" , "I hold firefighters in the highest regard." , "20150607_160628.png" ],
 [ "arson" , "I spent a lot of time working arson,  which is why I know that Paul Satterfield  was hung out to dry yesterday during that house fire." , "20150607_160813.png" ],
 [ "pawing" , "Really?  An Atlanta woman credits her dog Floyd Henry  for pawing a cancerous tumor which saved her life." , "20150607_160949.png" ],
 [ "canine" , "Why do I remember that?  In any case, on my command, our canine friend here  will use his extrasensory perception  to sniff out a killer's guilt  And I do believe he's found it." , "20150607_161011.png" ],
 [ "kipper" , "What's this?  Smoked kipper." , "20150607_161050.png" ],
 [ "red her" , "Also known as red herring." , "20150607_161059.png" ],
 [ "pouncing" , "When Hoser here was, uh, pouncing on my rescuer,  I couldn't help but notice a profound sense of relief  from  you, sir." , "20150607_161141.png" ],
 [ "riled up" , "Heard you riled 'em up in there." , "20150607_161340.png" ],
 [ "spinach" , "Is anything coming back to you?  Kids prefer cheese over fried green spinach." , "20150607_161405.png" ],
 [ "Come again" , "Come again?  It's an acronym for the seven levels of taxonomy--  kingdom, phylum, class, order, family, genus, species." , "20150607_161416.png" ],
 [ "acronym" , "Come again?  It's an acronym for the seven levels of taxonomy--  kingdom, phylum, class, order, family, genus, species." , "20150607_161430.png" ],
 [ "taxonomy" , "Come again?  It's an acronym for the seven levels of taxonomy--  kingdom, phylum, class, order, family, genus, species." , "20150607_161457.png" ],
 [ "trip up" , "The doctor says it's your emotional memories  that are tripping you up." , "20150607_161616.png" ],
 [ "get over on" , "So you wear a wedding ring to get over on women?  Worked on you." , "20150607_161658.png" ],
 [ "bidding" , "Cho,  and I'll do your bidding,  but first I wanna take a look at this burned-out house." , "20150607_162121.png" ],
 [ "cheat death" , "Well, we both cheated death." , "20150607_162243.png" ],
 [ "brazen" , "Satterfield, but you're quite brazen." , "20150607_162347.png" ],
 [ "double down" , "Well, she doubled down on her husband's life insurance policy  a month before his murder." , "20150607_162419.png" ],
 [ "up policy" , "Drinking in all that glory,  dancing in the fire  How do you compete with the high of being a hero?  Hmm?  Why didn't you just leave him?  And what kind of a settlement  am I gonna get from a firefighter?  I upped the policy because his death was just a matter of time." , "20150607_162549.png" ],
 [ "hustler" , "Without those reasons, you're a hustler." , "20150607_162758.png" ],
 [ "conned" , "I'm the one he conned." , "20150607_163042.png" ],
 [ "mark" , "We were all marks today." , "20150607_163113.png" ],
 [ "rain check" , "I'm gonna take a rain check on that." , "20150607_163528.png" ],
 [ "put fork" , "Actually, put a fork in it." , "20150607_163630.png" ],
 [ "parting" , "My parting gift to you I will give tomorrow morning." , "20150607_163833.png" ],
 [ "pegged" , "I had you pegged from the start." , "20150607_164222.png" ],
 [ "good match" , "The colors are a good match, though, don't you think?  Hands in the air where I can see them!  Do it now!  Turn around." , "20150607_164542.png" ],
 [ "accomplice" , "I'd look for an accomplice." , "20150607_164641.png" ]]

vocab_lists.each do |arr|
  rb_t_s_e.vocabs.find_or_create_by(:word     => arr[0],
                                    :sentence => arr[1],
                                    :picture  => arr[2])
end

