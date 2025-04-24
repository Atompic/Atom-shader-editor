shader_type canvas_item;

//risky_distance helps imrove render distance with near 0 fps hit beaks down at higher numbers and plan to remove

uniform float Risky_Distance : hint_range(0.1, 25.0, 0.1);
uniform int MAX_STEPS        : hint_range(15, 300, 5)=75;
uniform float MAX_DISTANCE   : hint_range(0.0, 10000.0, 50.)= 1000.;
uniform float MIN_DISTANCE   : hint_range(0.0002, 0.05, 0.002)= .01;
uniform float Clamp_Max      : hint_range(1.0, 10.0, .1)= 10.;
uniform float Water_travel   : hint_range(0.0, 10.0, 0.1)= 1.;
uniform float Buffer_range   : hint_range(0.0, .1, 0.001)= 0.025;
uniform float performance    : hint_range(0.0, 2.0, 0.1);

//uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

//global uniform float global_time;




float Time(){
	float global_time = -1.;
	if(global_time>0.){return global_time;}
	else{return TIME;}
}

float calcWaveDistance(vec3 P, float time, int iterationCount, vec2 primaryDirection) {
  // P: world space position of the point (vec3)
  // time: global time value (e.g., from uniform) (float)
  // iterationCount: number of iterations for wave simulation (int)
  // primaryDirection: normalized vector representing the main wave direction (vec2)

  float totalDistance = 0.0;
  float baseFrequency = 0.02;
  float dampingFactor = 0.8;

  for (int i = 0; i < iterationCount; ++i) {
    // Calculate frequency based on iteration (higher iterations have higher frequencies)
    float frequency = baseFrequency * exp2(float(i));

    // Calculate decreasing amplitude based on iteration
    float amplitude = 0.5 / (0.1 + float(i) * dampingFactor);

    // Generate random offset based on time and iteration
    float offset = sin(time + dot(P.xz * primaryDirection, vec2(frequency)) + float(i) * 0.5);

    // Add weighted contribution from this iteration
    totalDistance += amplitude * sin(dot(P.xz, vec2(frequency)) + offset);
  }

  return clamp(totalDistance,-100.,100.)-10. ;
}


mat3 raymarch(vec3 ray_origin, vec3 ray_dir,float linear_depth,vec2 uv) {
    float t = 0.0;
	float MD =linear_depth;
	float M_D= MIN_DISTANCE;
    vec3 p = ray_origin;
	float hight=0.;
	float dist=0.;
	float rd=0.;
	float td=0.;
	float mipmapsdf=0.;
	float ld=0.;
	//water depth
	float WD=0.;
	vec3 HP=vec3(0.);
	vec3 Col=vec3(0.);
	
	//int boost=int(float(MAX_STEPS)*0.7);
	int boost=MAX_STEPS;
	
	int near_Boost=10;
	//if(p.y < -3.) {return mat3(vec3(0.1,0.5,0.8)*max(((-tanh((-p.y-hight)*0.5)+1.0)),0.01),vec3(max(min(abs(p.y),1.),0.7)),vec3(0.));}
    for (int i = 0; i < MAX_STEPS; i++)
    {
		//float R_D = Risky_Distance*(float(i)/float(MAX_STEPS));
		
		ld = td;
        //hight = get_distance(p,50); 
		dist = p.y-(calcWaveDistance(p,Time(),near_Boost,vec2(0.,1.))-M_D*1.1);
		td = max(dist,Buffer_range);
        //t += d;
	
		if(t>MAX_DISTANCE || (t>MD && t-0.02>rd) ){break;}
		
		
		
		
		p = ray_origin + ray_dir * t;
		
		if(i>boost)t*=Clamp_Max;
		t += td; 
		
		M_D = MIN_DISTANCE * (t*Risky_Distance);
		
		if(p.y>ray_origin.y+20.){break;}
		
		if(dist>2.){near_Boost=1;}
		if(dist<2.){near_Boost=2;}
		if(dist<M_D*3.){near_Boost=7;}
		
	
		
        if (dist<M_D && i>12){
		
		
		
		if(uv.x+1.>performance) return mat3(vec3(float(i)*0.01,1.-float(i)*0.01,0.),vec3(1.),vec3(0.));
		//return mat3(vec3(dist*0.1,dist*0.1,dist*1.),vec3(1.),vec3(0.));
		
		
		//return mat3(Col,vec3(Water_travel),vec3(0.));
		
		
		//if(p.y<hight)return mat3(vec3(0.1,0.5,0.8)*max(((-tanh((-p.y-hight)*0.5)+1.0)),0.01)*WD,vec3(max(min(abs(d),1.),0.7)),vec3(0.));
		//return mat3(vec3(0.1,0.5,0.8)*max(((-tanh(-p.y-hight*0.5)+1.0))    +dot(get_normal(p),ray_dir)*0.7      ,0.01),vec3(max(min(abs(d),1.),0.7)),vec3(0.));
		
		return mat3(( vec3(0.1,0.5,0.8)*((p.y+30.0)*0.03) ),vec3(1.),vec3(0.));
		
		//return mat3(smoothstep( vec3(0.1,0.5,0.8)*(-(p.y+15.0)*0.03),  vec3(1.)    ,vec3(smoothstep(dist+0.1,0.,0.9)) ),vec3(1.),vec3(0.));
     }}
    return mat3(0.);
}



void fragment() {
	
	//float depth = texture(DEPTH_TEXTURE,SCREEN_UV).x;
	float depth = 0. ;
	vec3 ndc = vec3(SCREEN_UV*2.0 - 1.0,depth);
/*	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc,1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	
    vec2 uv = SCREEN_UV * 2.0 - 1.0;
    vec4 camera = INV_VIEW_MATRIX  * INV_PROJECTION_MATRIX * vec4(uv, 1, 1);

    vec3 ray_origin = INV_VIEW_MATRIX[3].xyz + vec3(0.,1.,0.);
    vec3 ray_dir = normalize(camera.xyz);

*/
	vec3 ray_origin = vec3(0.,-10.,0.);
	vec3 ray_dir    = vec3(0.,1.,0.0);
	float linear_depth = 0.;
	
    mat3 raymarch = raymarch(ray_origin, ray_dir,linear_depth,UV);
	vec4 col;
	col.rgb = raymarch[0];
	col.a = raymarch[1].x;


    COLOR = vec4(col.rgb,1.);
}