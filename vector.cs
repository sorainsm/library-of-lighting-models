    public class Vector
    {
        float ux;
        float uy;
        float uz;
        float m;
        Point3D start;
        
        public Vector(Point3D p, Point3D q)
        {
            if((p.x==q.x)&&(p.y==q.y)&&(p.z==q.z)){
                throw new System.ArgumentException("These are the same points.");
            }      
            
            start = p;
            m = start.distance_abs(q)
            ux = (q.x - p.x)/m;
            uy = (q.y - p.y)/m;
            uz = (q.z - p.z)/m;
        }

        public Vector(float Ix, float Iy, float Iz, float Im)
        {            
            ux = Ix;
            uy = Iy;
            uz = Iz;
            m = Im;
            
            if((ux < -1)||(ux > 1)){
                throw new System.ArgumentException("Invalid Ux value.");
            } 
            if((uy < -1)||(uy > 1)){
                throw new System.ArgumentException("Invalid Uy value.");
            } 
            if((uz < -1)||(uz > 1)){
                throw new System.ArgumentException("Invalid Uz value.");
            } 
            if(m < 0){
                throw new System.ArgumentException("Invalid m value.");
            } 
        }
        
        public m()
        {
            return m;
        }
        
        public direction()
        {
            float[] directions = new float[] {ux, uy, uz};
            return directions;
        }
    }
