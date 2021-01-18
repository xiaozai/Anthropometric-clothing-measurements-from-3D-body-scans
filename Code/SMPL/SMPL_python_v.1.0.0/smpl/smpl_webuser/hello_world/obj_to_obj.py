import bpy
import sys

# argv = sys.argv
# argv = argv[argv.index("--") + 1:]

# delete the initial CUBE object, remaining camera and lamb
candidate_list = [item.name for item in bpy.data.objects if item.type == "MESH"]

# select them only.
for object_name in candidate_list:
  bpy.data.objects[object_name].select = True

# remove all selected.
bpy.ops.object.delete()

# remove the meshes, they have no users anymore.
for item in bpy.data.meshes:
	bpy.data.meshes.remove(item)



obj_in = '/home/yan/Data2/3D_Human_Body_Estimation/AlignmentUI/SMPL_out/test.obj'
obj_out = '/home/yan/Data2/3D_Human_Body_Estimation/AlignmentUI/blender_out/test.obj'

bpy.ops.import_scene.obj(filepath=obj_in)
bpy.ops.export_scene.obj(filepath=obj_out, use_normals=True)
