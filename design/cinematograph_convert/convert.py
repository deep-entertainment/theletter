import yaml
import chevron
import soundfile
import math
import os.path

stream = open('cinematograph.yaml', 'r')

cinematograph = yaml.load(stream, Loader = yaml.SafeLoader)

stream.close()

template_file = open('scenefile.mustache', 'r')
template = template_file.read()
template_file.close()

for reelname, reel in cinematograph["cinematograph"].items():
  print('"%s",' % reelname)
  for sceneindex in range(len(reel)):
    (character, text) = reel[sceneindex].split('|')
    context = {
      "has_voice": False,
      "scene_name": '%s.%d' % (reelname, sceneindex),
      "scene_length": 10,
      "character_color": cinematograph['characters'][character],
      "text": text 
    }
    if os.path.exists('../game/voices/%s.%d.ogg' % (reelname, sceneindex + 1)):
      context['has_voice'] = True
      context['voice_file'] = '%s.%d.ogg' % (reelname, sceneindex + 1)
      voice_info = soundfile.info('../game/voices/%s.%d.ogg' % (reelname, sceneindex + 1)) 
      context['scene_length'] = math.floor(voice_info.duration) + 0.5 
   
    scene_file = open('../game/cinematograph_reels/%s.%d.tres' % (reelname, sceneindex), 'w')
    scene_file.write(chevron.render(template, context))
    scene_file.close()
