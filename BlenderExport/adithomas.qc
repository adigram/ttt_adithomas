$modelname		"adithomas\ttt_adithomas.mdl"
$attachment "eyes" "Head" 0.00 -97.29 94.04 absolute
$model adithomas "adithomas.smd" {
	eyeball righteye "Head" -9.84 -97.29 94.04 "mat_eyeR" 1.00 2 "noirisuu" 8.50
	eyeball lefteye "Head" 9.84 -97.29 94.04 "mat_eyeL" 1.00 -2 "noirisuu" 8.50
}
$contents 		"solid"
$surfaceprop	metal
$cdmaterials	"adithomas"

$sequence wheel_ani	"anims\wheel_ani.smd" {
loop
}

$collisionmodel	"adithomas_col.smd" { $concave }

