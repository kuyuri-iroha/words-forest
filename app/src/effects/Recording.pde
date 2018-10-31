// レコーディング状態を扱う
class Recording
{
  String fileName;
  boolean recording;
  BufferedReader reader;
  
  Recording(String _fileName)
  {
    recording = false;
    fileName = _fileName;
    reader = createReader(fileName);
  }
  
  void start()
  {
    recording = true;
    saveStrings(fileName, new String[]{"recording"});
  }
  
  void setEnded()
  {
    recording = false;
  }
  
  void update()
  {
    String[] ms = null;
    if(recording)
    {
      ms = loadStrings(fileName);
    }
    
    if(ms != null && ms[0].equals("ENDED"))
    {
      recording = false;
    }
  }
  
  void display()
  {
    if(recording)
    {
      textAlign(RIGHT, TOP);
      textSize(10);
      text("Recording...", width, 0);
    }
  }
}
