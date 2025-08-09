import bpy

def get_target_directions() -> list:
    return ["backward", "forward", "left", "right",
    "forward-left", "forward-right", "backward-left", "backward-right"]

def get_heroes() -> list: return ["ray", "rock"]

def set_main_camera(direction: str) -> None:
    camera = bpy.data.objects[direction + '-camera']
    bpy.context.scene.camera = camera

def set_bsdf_image(hero: str, tree) -> None:
    bsdf = tree.nodes["Principled BSDF"]
    target = tree.nodes.new('ShaderNodeTexImage')
    target.image = bpy.data.images[hero + '.png']
    tree.links.new(bsdf.inputs['Base Color'], target.outputs['Color'])

def set_hero_texture(hero: str) -> None:
    material = bpy.data.materials['Material']
    material.use_nodes = True
    set_bsdf_image(hero, material.node_tree)

def set_render_type(animation: bool) -> None:
    if animation:
        bpy.ops.render.render(animation=True)
    else:
        bpy.ops.render.render(write_still=True)

def render_target(directory: str) -> None:
    render = bpy.context.scene.render
    root_path = render.filepath
    render.filepath = root_path + '/' + directory + '/'
    set_render_type(True)
    render.filepath = root_path

def set_lighting(target_directory: str, light) -> None:
    light.hide_set(False)
    render_target(target_directory)
    light.hide_set(True)

def direct_render(hero: str) -> None:
    for direction in get_target_directions():
        set_main_camera(direction)
        set_lighting(hero + '/' + direction, bpy.data.objects[direction + '-light'])

def start_render() -> None:
    for hero in get_heroes():
        set_hero_texture(hero)
        direct_render(hero)

start_render()