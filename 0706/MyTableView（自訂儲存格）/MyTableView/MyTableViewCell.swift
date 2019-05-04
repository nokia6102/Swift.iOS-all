import UIKit

class MyTableViewCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
