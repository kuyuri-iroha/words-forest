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
    if(recording)
    {
      recording = false;
      saveStrings(fileName, new String[]{"EndRq"});
    }
    else
    {
      recording = true;
      saveStrings(fileName, new String[]{"recording"});
    }
  }

  void update()
  {
  }

  void display()
  {
  }
}